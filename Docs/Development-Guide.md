# Development Guide

## Overview

This guide provides comprehensive development practices and guidelines for contributing to the REChain DAO Platform.

## Table of Contents

1. [Development Environment](#development-environment)
2. [Code Standards](#code-standards)
3. [Git Workflow](#git-workflow)
4. [Testing Practices](#testing-practices)
5. [Documentation Standards](#documentation-standards)
6. [Code Review Process](#code-review-process)
7. [Debugging & Troubleshooting](#debugging--troubleshooting)

## Development Environment

### Prerequisites

- **Node.js**: 18.0.0+
- **npm**: 8.0.0+
- **MySQL**: 8.0+
- **Redis**: 6.0+
- **Git**: 2.30+
- **VS Code**: Recommended IDE

### Setup Instructions

```bash
# Clone repository
git clone https://github.com/your-username/rechain-dao.git
cd rechain-dao

# Install dependencies
npm install

# Copy environment file
cp env.example .env

# Edit environment variables
nano .env

# Start development services
docker-compose -f docker-compose.dev.yml up -d

# Run database migrations
npm run db:migrate

# Seed database
npm run db:seed

# Start development server
npm run dev
```

### VS Code Configuration

```json
// .vscode/settings.json
{
  "typescript.preferences.importModuleSpecifier": "relative",
  "typescript.suggest.autoImports": true,
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true,
    "source.organizeImports": true
  },
  "files.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/coverage": true
  },
  "eslint.workingDirectories": ["./"],
  "eslint.validate": ["javascript", "typescript"]
}
```

## Code Standards

### TypeScript Guidelines

```typescript
// Use explicit types
interface User {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  role: UserRole;
  createdAt: Date;
  updatedAt: Date;
}

// Use enums for constants
enum UserRole {
  USER = 'user',
  MODERATOR = 'moderator',
  ADMIN = 'admin'
}

// Use generics for reusable code
interface ApiResponse<T> {
  data: T;
  message: string;
  success: boolean;
}

// Use strict null checks
function getUser(id: string): User | null {
  const user = users.find(u => u.id === id);
  return user || null;
}
```

### Naming Conventions

```typescript
// Variables and functions: camelCase
const userName = 'john_doe';
const getUserById = (id: string) => { /* ... */ };

// Classes: PascalCase
class UserService {
  // ...
}

// Constants: UPPER_SNAKE_CASE
const MAX_RETRY_ATTEMPTS = 3;
const API_BASE_URL = 'https://api.rechain-dao.com';

// Interfaces: PascalCase with I prefix
interface IUserRepository {
  findById(id: string): Promise<User | null>;
  save(user: User): Promise<User>;
}

// Enums: PascalCase
enum ProposalStatus {
  DRAFT = 'draft',
  ACTIVE = 'active',
  PASSED = 'passed',
  REJECTED = 'rejected'
}
```

### File Organization

```
src/
├── controllers/          # Request handlers
├── services/            # Business logic
├── models/              # Data models
├── middleware/          # Express middleware
├── routes/              # Route definitions
├── utils/               # Utility functions
├── types/               # TypeScript type definitions
├── config/              # Configuration files
├── tests/               # Test files
└── app.ts               # Application entry point
```

### Import/Export Guidelines

```typescript
// Prefer named exports
export const UserService = {
  // ...
};

// Use default exports for main classes
export default class UserController {
  // ...
}

// Group imports
import React, { useState, useEffect } from 'react';
import { Request, Response, NextFunction } from 'express';
import { UserService } from '../services/UserService';
import { validateUser } from '../utils/validation';
import { User, CreateUserRequest } from '../types/user';
```

## Git Workflow

### Branch Naming

```bash
# Feature branches
feature/user-authentication
feature/proposal-creation
feature/voting-system

# Bug fix branches
bugfix/login-validation-error
bugfix/proposal-display-issue

# Hotfix branches
hotfix/security-vulnerability
hotfix/critical-bug

# Documentation branches
docs/api-documentation
docs/user-guide
```

### Commit Messages

```bash
# Format: type(scope): description
feat(auth): add JWT authentication
fix(api): resolve CORS issues
docs(readme): update installation instructions
refactor(services): improve error handling
test(proposals): add unit tests
chore(deps): update dependencies
```

### Pull Request Process

1. **Create feature branch**
   ```bash
   git checkout -b feature/new-feature
   ```

2. **Make changes and commit**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

3. **Push branch**
   ```bash
   git push origin feature/new-feature
   ```

4. **Create pull request**
   - Use descriptive title
   - Add detailed description
   - Link related issues
   - Request appropriate reviewers

5. **Address feedback**
   - Make requested changes
   - Respond to comments
   - Update documentation

6. **Merge after approval**
   - Squash and merge for feature branches
   - Merge commit for release branches

## Testing Practices

### Unit Testing

```typescript
// test/services/UserService.test.ts
import { UserService } from '../../src/services/UserService';
import { User } from '../../src/models/User';

describe('UserService', () => {
  let userService: UserService;

  beforeEach(() => {
    userService = new UserService();
  });

  describe('createUser', () => {
    it('should create user with valid data', async () => {
      const userData = {
        email: 'test@example.com',
        firstName: 'Test',
        lastName: 'User'
      };

      const user = await userService.createUser(userData);

      expect(user).toBeDefined();
      expect(user.email).toBe(userData.email);
    });

    it('should throw error for duplicate email', async () => {
      const userData = {
        email: 'existing@example.com',
        firstName: 'Test',
        lastName: 'User'
      };

      await expect(userService.createUser(userData))
        .rejects.toThrow('Email already exists');
    });
  });
});
```

### Integration Testing

```typescript
// test/integration/ProposalAPI.test.ts
import request from 'supertest';
import app from '../../src/app';
import { User } from '../../src/models/User';

describe('Proposal API', () => {
  let authToken: string;
  let testUser: User;

  beforeEach(async () => {
    // Setup test user
    testUser = await User.create({
      email: 'test@example.com',
      password: 'password123'
    });

    // Get auth token
    const response = await request(app)
      .post('/api/auth/login')
      .send({
        email: 'test@example.com',
        password: 'password123'
      });

    authToken = response.body.token;
  });

  it('should create proposal with valid data', async () => {
    const proposalData = {
      title: 'Test Proposal',
      description: 'Test Description',
      type: 'governance'
    };

    const response = await request(app)
      .post('/api/proposals')
      .set('Authorization', `Bearer ${authToken}`)
      .send(proposalData)
      .expect(201);

    expect(response.body.title).toBe(proposalData.title);
  });
});
```

### Test Coverage

```bash
# Run tests with coverage
npm run test:coverage

# Coverage thresholds
# Statements: 80%
# Branches: 75%
# Functions: 80%
# Lines: 80%
```

## Documentation Standards

### Code Documentation

```typescript
/**
 * Service for managing user operations
 * @class UserService
 */
class UserService {
  /**
   * Creates a new user
   * @param userData - User data
   * @returns Promise<User> - Created user
   * @throws {Error} When email already exists
   * @example
   * const user = await userService.createUser({
   *   email: 'test@example.com',
   *   firstName: 'Test',
   *   lastName: 'User'
   * });
   */
  async createUser(userData: CreateUserRequest): Promise<User> {
    // Implementation
  }
}
```

### API Documentation

```typescript
/**
 * @swagger
 * /api/proposals:
 *   post:
 *     summary: Create a new proposal
 *     tags: [Proposals]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/CreateProposalRequest'
 *     responses:
 *       201:
 *         description: Proposal created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Proposal'
 *       400:
 *         description: Invalid request data
 *       401:
 *         description: Unauthorized
 */
```

### README Documentation

```markdown
# Feature Name

Brief description of the feature.

## Usage

```typescript
import { FeatureService } from './FeatureService';

const service = new FeatureService();
const result = await service.doSomething();
```

## API

### Methods

#### `doSomething()`
Performs some operation.

**Returns:** `Promise<Result>`

**Throws:** `Error` when operation fails

## Examples

### Basic Usage
```typescript
// Example code
```

### Advanced Usage
```typescript
// More complex example
```

## Configuration

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| option1 | string | 'default' | Description |
| option2 | number | 100 | Description |
```

## Code Review Process

### Review Checklist

- [ ] **Functionality**
  - [ ] Code works as expected
  - [ ] Edge cases are handled
  - [ ] Error handling is appropriate

- [ ] **Code Quality**
  - [ ] Code is readable and maintainable
  - [ ] Naming conventions are followed
  - [ ] No code duplication
  - [ ] Performance considerations

- [ ] **Testing**
  - [ ] Unit tests are included
  - [ ] Integration tests are included
  - [ ] Test coverage is adequate
  - [ ] Tests are meaningful

- [ ] **Documentation**
  - [ ] Code is documented
  - [ ] API documentation is updated
  - [ ] README is updated if needed

- [ ] **Security**
  - [ ] Input validation is present
  - [ ] No security vulnerabilities
  - [ ] Sensitive data is protected

### Review Guidelines

1. **Be constructive** - Focus on improving the code
2. **Be specific** - Point out exact issues
3. **Be respectful** - Maintain professional tone
4. **Be thorough** - Check all aspects
5. **Be timely** - Respond within 24 hours

## Debugging & Troubleshooting

### Debugging Tools

```typescript
// Use console.log for debugging
console.log('Debug info:', { userId, proposalId });

// Use debugger for step-by-step debugging
debugger;

// Use logging framework
import logger from '../utils/logger';
logger.debug('Debug message', { context: 'value' });
```

### Common Issues

#### 1. Database Connection Issues

```bash
# Check MySQL status
sudo systemctl status mysql

# Check connection
mysql -u root -p -e "SELECT 1;"

# Check environment variables
echo $DB_HOST $DB_PORT $DB_NAME
```

#### 2. Redis Connection Issues

```bash
# Check Redis status
sudo systemctl status redis

# Test connection
redis-cli ping

# Check Redis logs
sudo journalctl -u redis
```

#### 3. Port Already in Use

```bash
# Find process using port
lsof -i :3000

# Kill process
kill -9 <PID>

# Or use different port
PORT=3001 npm run dev
```

### Performance Debugging

```typescript
// Measure function execution time
const start = performance.now();
await someFunction();
const end = performance.now();
console.log(`Function took ${end - start} milliseconds`);

// Memory usage
const used = process.memoryUsage();
console.log('Memory usage:', {
  rss: Math.round(used.rss / 1024 / 1024) + ' MB',
  heapTotal: Math.round(used.heapTotal / 1024 / 1024) + ' MB',
  heapUsed: Math.round(used.heapUsed / 1024 / 1024) + ' MB'
});
```

## Best Practices

### 1. Error Handling

```typescript
// Use try-catch for async operations
try {
  const result = await someAsyncOperation();
  return result;
} catch (error) {
  logger.error('Operation failed:', error);
  throw new Error('Operation failed');
}

// Use specific error types
class ValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'ValidationError';
  }
}
```

### 2. Data Validation

```typescript
import Joi from 'joi';

const userSchema = Joi.object({
  email: Joi.string().email().required(),
  firstName: Joi.string().min(2).max(50).required(),
  lastName: Joi.string().min(2).max(50).required()
});

const validateUser = (userData: any) => {
  const { error, value } = userSchema.validate(userData);
  if (error) {
    throw new ValidationError(error.details[0].message);
  }
  return value;
};
```

### 3. Security

```typescript
// Sanitize input
import DOMPurify from 'dompurify';

const sanitizeInput = (input: string): string => {
  return DOMPurify.sanitize(input);
};

// Use parameterized queries
const getUserById = async (id: string) => {
  const query = 'SELECT * FROM users WHERE id = ?';
  const [rows] = await db.execute(query, [id]);
  return rows[0];
};
```

## Conclusion

This development guide provides comprehensive practices for contributing to the REChain DAO Platform. Following these guidelines ensures code quality, maintainability, and team collaboration.

For additional support, please refer to our [documentation](docs/) or contact our [development team](mailto:dev@rechain-dao.com).
