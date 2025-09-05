# Руководство по тестированию API

## Обзор

Это руководство предоставляет комплексные стратегии и инструменты для тестирования API платформы REChain DAO, включая автоматизированное тестирование, тестирование безопасности и производительности.

## Содержание

1. [Стратегии тестирования](#стратегии-тестирования)
2. [Автоматизированное тестирование](#автоматизированное-тестирование)
3. [Тестирование безопасности](#тестирование-безопасности)
4. [Тестирование производительности](#тестирование-производительности)
5. [Инструменты тестирования](#инструменты-тестирования)
6. [Лучшие практики](#лучшие-практики)

## Стратегии тестирования

### Типы тестирования

#### 1. Функциональное тестирование
```javascript
// Тест создания пользователя
describe('User API', () => {
  test('should create user successfully', async () => {
    const userData = {
      username: 'testuser',
      email: 'test@example.com',
      password: 'securepassword123'
    };
    
    const response = await request(app)
      .post('/api/users')
      .send(userData)
      .expect(201);
    
    expect(response.body).toHaveProperty('id');
    expect(response.body.username).toBe(userData.username);
  });
});
```

#### 2. Тестирование валидации
```javascript
// Тест валидации данных
describe('Validation Tests', () => {
  test('should reject invalid email', async () => {
    const invalidData = {
      username: 'testuser',
      email: 'invalid-email',
      password: 'password123'
    };
    
    const response = await request(app)
      .post('/api/users')
      .send(invalidData)
      .expect(400);
    
    expect(response.body).toHaveProperty('errors');
    expect(response.body.errors).toContain('Invalid email format');
  });
});
```

#### 3. Тестирование аутентификации
```javascript
// Тест аутентификации
describe('Authentication Tests', () => {
  test('should require valid token for protected routes', async () => {
    const response = await request(app)
      .get('/api/users/profile')
      .expect(401);
    
    expect(response.body).toHaveProperty('error', 'Unauthorized');
  });
  
  test('should allow access with valid token', async () => {
    const token = await getValidToken();
    
    const response = await request(app)
      .get('/api/users/profile')
      .set('Authorization', `Bearer ${token}`)
      .expect(200);
    
    expect(response.body).toHaveProperty('user');
  });
});
```

## Автоматизированное тестирование

### Настройка тестовой среды

#### 1. Конфигурация Jest
```javascript
// jest.config.js
module.exports = {
  testEnvironment: 'node',
  setupFilesAfterEnv: ['<rootDir>/tests/setup.js'],
  testMatch: ['**/__tests__/**/*.test.js'],
  collectCoverage: true,
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  testTimeout: 10000
};
```

#### 2. Настройка тестовой базы данных
```javascript
// tests/setup.js
const { MongoMemoryServer } = require('mongodb-memory-server');
const mongoose = require('mongoose');

let mongoServer;

beforeAll(async () => {
  mongoServer = await MongoMemoryServer.create();
  const mongoUri = mongoServer.getUri();
  await mongoose.connect(mongoUri);
});

afterAll(async () => {
  await mongoose.disconnect();
  await mongoServer.stop();
});

beforeEach(async () => {
  // Очистка базы данных перед каждым тестом
  const collections = mongoose.connection.collections;
  for (const key in collections) {
    await collections[key].deleteMany({});
  }
});
```

### Тестирование API endpoints

#### 1. CRUD операции
```javascript
// tests/api/users.test.js
const request = require('supertest');
const app = require('../../app');

describe('Users API', () => {
  let userId;
  
  describe('POST /api/users', () => {
    test('should create a new user', async () => {
      const userData = {
        username: 'newuser',
        email: 'newuser@example.com',
        password: 'password123'
      };
      
      const response = await request(app)
        .post('/api/users')
        .send(userData)
        .expect(201);
      
      userId = response.body.id;
      expect(response.body.username).toBe(userData.username);
    });
  });
  
  describe('GET /api/users/:id', () => {
    test('should get user by id', async () => {
      const response = await request(app)
        .get(`/api/users/${userId}`)
        .expect(200);
      
      expect(response.body.id).toBe(userId);
    });
  });
  
  describe('PUT /api/users/:id', () => {
    test('should update user', async () => {
      const updateData = { username: 'updateduser' };
      
      const response = await request(app)
        .put(`/api/users/${userId}`)
        .send(updateData)
        .expect(200);
      
      expect(response.body.username).toBe(updateData.username);
    });
  });
  
  describe('DELETE /api/users/:id', () => {
    test('should delete user', async () => {
      await request(app)
        .delete(`/api/users/${userId}`)
        .expect(204);
    });
  });
});
```

#### 2. Тестирование пагинации
```javascript
// Тест пагинации
describe('Pagination Tests', () => {
  test('should return paginated results', async () => {
    // Создаем тестовые данные
    await createTestUsers(25);
    
    const response = await request(app)
      .get('/api/users?page=1&limit=10')
      .expect(200);
    
    expect(response.body.data).toHaveLength(10);
    expect(response.body.pagination.page).toBe(1);
    expect(response.body.pagination.total).toBe(25);
    expect(response.body.pagination.pages).toBe(3);
  });
});
```

## Тестирование безопасности

### 1. Тестирование аутентификации
```javascript
// tests/security/auth.test.js
describe('Security Tests', () => {
  describe('Authentication', () => {
    test('should prevent brute force attacks', async () => {
      const loginData = {
        email: 'test@example.com',
        password: 'wrongpassword'
      };
      
      // Попытка 5 неудачных входов
      for (let i = 0; i < 5; i++) {
        await request(app)
          .post('/api/auth/login')
          .send(loginData)
          .expect(401);
      }
      
      // 6-я попытка должна заблокировать аккаунт
      const response = await request(app)
        .post('/api/auth/login')
        .send(loginData)
        .expect(429);
      
      expect(response.body.error).toContain('Account locked');
    });
  });
});
```

### 2. Тестирование авторизации
```javascript
// Тест авторизации
describe('Authorization Tests', () => {
  test('should prevent unauthorized access to admin routes', async () => {
    const userToken = await getUserToken();
    
    const response = await request(app)
      .get('/api/admin/users')
      .set('Authorization', `Bearer ${userToken}`)
      .expect(403);
    
    expect(response.body.error).toContain('Insufficient permissions');
  });
});
```

### 3. Тестирование валидации входных данных
```javascript
// Тест SQL инъекций
describe('Input Validation Tests', () => {
  test('should prevent SQL injection', async () => {
    const maliciousInput = "'; DROP TABLE users; --";
    
    const response = await request(app)
      .get(`/api/users?search=${maliciousInput}`)
      .expect(400);
    
    expect(response.body.error).toContain('Invalid input');
  });
  
  test('should prevent XSS attacks', async () => {
    const xssPayload = '<script>alert("XSS")</script>';
    
    const response = await request(app)
      .post('/api/posts')
      .send({ content: xssPayload })
      .expect(400);
    
    expect(response.body.error).toContain('Invalid content');
  });
});
```

## Тестирование производительности

### 1. Нагрузочное тестирование
```javascript
// tests/performance/load.test.js
const autocannon = require('autocannon');

describe('Performance Tests', () => {
  test('should handle concurrent requests', async () => {
    const result = await autocannon({
      url: 'http://localhost:3000/api/users',
      connections: 100,
      duration: 10,
      requests: [
        {
          method: 'GET',
          path: '/api/users'
        }
      ]
    });
    
    expect(result.requests.average).toBeGreaterThan(100);
    expect(result.latency.average).toBeLessThan(1000);
  });
});
```

### 2. Тестирование времени отклика
```javascript
// Тест времени отклика
describe('Response Time Tests', () => {
  test('should respond within acceptable time', async () => {
    const startTime = Date.now();
    
    const response = await request(app)
      .get('/api/users')
      .expect(200);
    
    const responseTime = Date.now() - startTime;
    expect(responseTime).toBeLessThan(500); // 500ms
  });
});
```

## Инструменты тестирования

### 1. Postman Collections
```json
{
  "info": {
    "name": "REChain DAO API Tests",
    "description": "Comprehensive API test collection"
  },
  "item": [
    {
      "name": "Authentication",
      "item": [
        {
          "name": "Login",
          "request": {
            "method": "POST",
            "header": [
              {
                "key": "Content-Type",
                "value": "application/json"
              }
            ],
            "body": {
              "mode": "raw",
              "raw": "{\n  \"email\": \"test@example.com\",\n  \"password\": \"password123\"\n}"
            },
            "url": {
              "raw": "{{base_url}}/api/auth/login",
              "host": ["{{base_url}}"],
              "path": ["api", "auth", "login"]
            }
          },
          "response": []
        }
      ]
    }
  ]
}
```

### 2. Newman (Postman CLI)
```bash
# Запуск тестов через Newman
newman run REChain-API-Tests.postman_collection.json \
  --environment REChain-Dev.postman_environment.json \
  --reporters cli,html \
  --reporter-html-export test-results.html
```

### 3. Artillery (Нагрузочное тестирование)
```yaml
# artillery-config.yml
config:
  target: 'http://localhost:3000'
  phases:
    - duration: 60
      arrivalRate: 10
    - duration: 120
      arrivalRate: 20
    - duration: 60
      arrivalRate: 10

scenarios:
  - name: "User API Load Test"
    weight: 70
    flow:
      - get:
          url: "/api/users"
      - post:
          url: "/api/users"
          json:
            username: "loadtest{{ $randomString() }}"
            email: "loadtest{{ $randomString() }}@example.com"
            password: "password123"
  - name: "Posts API Load Test"
    weight: 30
    flow:
      - get:
          url: "/api/posts"
      - post:
          url: "/api/posts"
          json:
            title: "Load Test Post {{ $randomString() }}"
            content: "This is a load test post"
```

## Лучшие практики

### 1. Организация тестов
```
tests/
├── unit/           # Модульные тесты
├── integration/    # Интеграционные тесты
├── e2e/           # End-to-end тесты
├── performance/   # Тесты производительности
├── security/      # Тесты безопасности
├── fixtures/      # Тестовые данные
├── helpers/       # Вспомогательные функции
└── setup.js      # Настройка тестовой среды
```

### 2. Именование тестов
```javascript
// Хорошие имена тестов
describe('User API', () => {
  describe('POST /api/users', () => {
    test('should create user with valid data', () => {});
    test('should return 400 for invalid email', () => {});
    test('should return 409 for duplicate username', () => {});
  });
});
```

### 3. Изоляция тестов
```javascript
// Каждый тест должен быть независимым
beforeEach(async () => {
  // Очистка базы данных
  await cleanDatabase();
  
  // Создание тестовых данных
  await createTestData();
});
```

### 4. Тестовые данные
```javascript
// Использование фабрик для тестовых данных
const userFactory = {
  create: (overrides = {}) => ({
    username: 'testuser',
    email: 'test@example.com',
    password: 'password123',
    ...overrides
  }),
  
  createMany: (count, overrides = {}) => 
    Array.from({ length: count }, () => userFactory.create(overrides))
};
```

## Заключение

Это руководство по тестированию API обеспечивает комплексный подход к тестированию платформы REChain DAO. Следуя этим стратегиям и используя рекомендуемые инструменты, вы можете обеспечить надежность, безопасность и производительность вашего API.

Помните: тестирование - это непрерывный процесс, который должен интегрироваться в ваш цикл разработки для обеспечения качества кода.
