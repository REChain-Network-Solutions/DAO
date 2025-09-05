# Руководство по оптимизации производительности

## Обзор

Это руководство предоставляет комплексные стратегии и техники для оптимизации производительности платформы REChain DAO, включая мониторинг, профилирование, кэширование и масштабирование.

## Содержание

1. [Мониторинг производительности](#мониторинг-производительности)
2. [Оптимизация базы данных](#оптимизация-базы-данных)
3. [Кэширование](#кэширование)
4. [CDN и статические ресурсы](#cdn-и-статические-ресурсы)
5. [Оптимизация кода](#оптимизация-кода)
6. [Масштабирование](#масштабирование)

## Мониторинг производительности

### 1. Метрики производительности

#### Ключевые показатели
```javascript
// performance-metrics.js
class PerformanceMetrics {
  constructor() {
    this.metrics = {
      responseTime: [],
      throughput: [],
      errorRate: [],
      memoryUsage: [],
      cpuUsage: []
    };
  }
  
  recordResponseTime(endpoint, duration) {
    this.metrics.responseTime.push({
      endpoint,
      duration,
      timestamp: Date.now()
    });
  }
  
  recordThroughput(requestsPerSecond) {
    this.metrics.throughput.push({
      rps: requestsPerSecond,
      timestamp: Date.now()
    });
  }
  
  getAverageResponseTime(endpoint) {
    const endpointMetrics = this.metrics.responseTime
      .filter(m => m.endpoint === endpoint);
    
    if (endpointMetrics.length === 0) return 0;
    
    const total = endpointMetrics.reduce((sum, m) => sum + m.duration, 0);
    return total / endpointMetrics.length;
  }
}
```

#### Мониторинг в реальном времени
```javascript
// real-time-monitoring.js
const prometheus = require('prom-client');

// Создание метрик
const httpRequestDuration = new prometheus.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  buckets: [0.1, 0.3, 0.5, 0.7, 1, 3, 5, 7, 10]
});

const httpRequestTotal = new prometheus.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status_code']
});

// Middleware для записи метрик
const metricsMiddleware = (req, res, next) => {
  const start = Date.now();
  
  res.on('finish', () => {
    const duration = (Date.now() - start) / 1000;
    
    httpRequestDuration
      .labels(req.method, req.route?.path || req.path, res.statusCode)
      .observe(duration);
    
    httpRequestTotal
      .labels(req.method, req.route?.path || req.path, res.statusCode)
      .inc();
  });
  
  next();
};
```

### 2. Профилирование приложения

#### Профилирование Node.js
```javascript
// profiling.js
const { performance, PerformanceObserver } = require('perf_hooks');

// Создание наблюдателя производительности
const obs = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    console.log(`${entry.name}: ${entry.duration}ms`);
  }
});

obs.observe({ entryTypes: ['measure', 'function'] });

// Измерение времени выполнения функций
function measureFunction(fn, name) {
  return function(...args) {
    performance.mark(`${name}-start`);
    const result = fn.apply(this, args);
    performance.mark(`${name}-end`);
    performance.measure(name, `${name}-start`, `${name}-end`);
    return result;
  };
}

// Использование
const optimizedFunction = measureFunction(heavyFunction, 'heavyFunction');
```

#### Профилирование памяти
```javascript
// memory-profiling.js
const v8 = require('v8');

class MemoryProfiler {
  constructor() {
    this.snapshots = [];
  }
  
  takeSnapshot() {
    const snapshot = {
      timestamp: Date.now(),
      heapUsed: process.memoryUsage().heapUsed,
      heapTotal: process.memoryUsage().heapTotal,
      external: process.memoryUsage().external,
      rss: process.memoryUsage().rss
    };
    
    this.snapshots.push(snapshot);
    return snapshot;
  }
  
  getMemoryGrowth() {
    if (this.snapshots.length < 2) return 0;
    
    const latest = this.snapshots[this.snapshots.length - 1];
    const previous = this.snapshots[this.snapshots.length - 2];
    
    return latest.heapUsed - previous.heapUsed;
  }
  
  generateHeapSnapshot() {
    const filename = `heap-${Date.now()}.heapsnapshot`;
    const stream = v8.getHeapSnapshot();
    const fileStream = require('fs').createWriteStream(filename);
    stream.pipe(fileStream);
    return filename;
  }
}
```

## Оптимизация базы данных

### 1. Индексы и запросы

#### Создание эффективных индексов
```sql
-- Составные индексы для частых запросов
CREATE INDEX idx_user_posts ON posts (user_id, created_at DESC);
CREATE INDEX idx_posts_status ON posts (status, created_at DESC);
CREATE INDEX idx_comments_post ON comments (post_id, created_at);

-- Частичные индексы
CREATE INDEX idx_active_users ON users (email) WHERE status = 'active';

-- Индексы для полнотекстового поиска
CREATE INDEX idx_posts_search ON posts USING gin(to_tsvector('english', title || ' ' || content));
```

#### Оптимизация запросов
```sql
-- Использование EXPLAIN для анализа запросов
EXPLAIN (ANALYZE, BUFFERS) 
SELECT p.*, u.username 
FROM posts p 
JOIN users u ON p.user_id = u.id 
WHERE p.status = 'published' 
  AND p.created_at > NOW() - INTERVAL '7 days'
ORDER BY p.created_at DESC 
LIMIT 20;

-- Оптимизированный запрос с подзапросом
SELECT p.*, u.username 
FROM (
  SELECT * FROM posts 
  WHERE status = 'published' 
    AND created_at > NOW() - INTERVAL '7 days'
  ORDER BY created_at DESC 
  LIMIT 20
) p
JOIN users u ON p.user_id = u.id;
```

### 2. Соединения и пулы

#### Настройка пула соединений
```javascript
// database-pool.js
const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST,
  port: process.env.DB_PORT,
  database: process.env.DB_NAME,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  max: 20, // Максимальное количество соединений
  min: 5,  // Минимальное количество соединений
  idleTimeoutMillis: 30000, // Таймаут неактивных соединений
  connectionTimeoutMillis: 2000, // Таймаут установки соединения
  acquireTimeoutMillis: 60000, // Таймаут получения соединения
  createTimeoutMillis: 30000, // Таймаут создания соединения
  destroyTimeoutMillis: 5000, // Таймаут закрытия соединения
  reapIntervalMillis: 1000, // Интервал проверки неактивных соединений
  createRetryIntervalMillis: 200, // Интервал повторных попыток
});

// Middleware для управления соединениями
const dbMiddleware = async (req, res, next) => {
  try {
    req.db = await pool.connect();
    next();
  } catch (error) {
    console.error('Database connection error:', error);
    res.status(500).json({ error: 'Database connection failed' });
  } finally {
    if (req.db) {
      req.db.release();
    }
  }
};
```

## Кэширование

### 1. Redis кэширование

#### Настройка Redis
```javascript
// redis-cache.js
const redis = require('redis');
const { promisify } = require('util');

class RedisCache {
  constructor() {
    this.client = redis.createClient({
      host: process.env.REDIS_HOST,
      port: process.env.REDIS_PORT,
      password: process.env.REDIS_PASSWORD,
      retry_strategy: (options) => {
        if (options.error && options.error.code === 'ECONNREFUSED') {
          return new Error('Redis server refused connection');
        }
        if (options.total_retry_time > 1000 * 60 * 60) {
          return new Error('Retry time exhausted');
        }
        if (options.attempt > 10) {
          return undefined;
        }
        return Math.min(options.attempt * 100, 3000);
      }
    });
    
    this.getAsync = promisify(this.client.get).bind(this.client);
    this.setAsync = promisify(this.client.set).bind(this.client);
    this.delAsync = promisify(this.client.del).bind(this.client);
  }
  
  async get(key) {
    try {
      const value = await this.getAsync(key);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      console.error('Redis get error:', error);
      return null;
    }
  }
  
  async set(key, value, ttl = 3600) {
    try {
      await this.setAsync(key, JSON.stringify(value), 'EX', ttl);
    } catch (error) {
      console.error('Redis set error:', error);
    }
  }
  
  async del(key) {
    try {
      await this.delAsync(key);
    } catch (error) {
      console.error('Redis delete error:', error);
    }
  }
}
```

#### Кэширование API ответов
```javascript
// api-cache.js
const cache = new RedisCache();

const cacheMiddleware = (ttl = 300) => {
  return async (req, res, next) => {
    const cacheKey = `api:${req.method}:${req.originalUrl}:${JSON.stringify(req.query)}`;
    
    try {
      const cached = await cache.get(cacheKey);
      if (cached) {
        return res.json(cached);
      }
      
      // Сохраняем оригинальный метод res.json
      const originalJson = res.json;
      
      res.json = function(data) {
        // Кэшируем ответ
        cache.set(cacheKey, data, ttl);
        
        // Вызываем оригинальный метод
        originalJson.call(this, data);
      };
      
      next();
    } catch (error) {
      console.error('Cache middleware error:', error);
      next();
    }
  };
};

// Использование
app.get('/api/posts', cacheMiddleware(600), getPosts);
app.get('/api/users/:id', cacheMiddleware(300), getUser);
```

### 2. Кэширование базы данных

#### Query кэширование
```javascript
// query-cache.js
class QueryCache {
  constructor() {
    this.cache = new Map();
    this.ttl = new Map();
  }
  
  get(key) {
    const ttl = this.ttl.get(key);
    if (ttl && Date.now() > ttl) {
      this.cache.delete(key);
      this.ttl.delete(key);
      return null;
    }
    return this.cache.get(key);
  }
  
  set(key, value, ttlSeconds = 300) {
    this.cache.set(key, value);
    this.ttl.set(key, Date.now() + (ttlSeconds * 1000));
  }
  
  invalidate(pattern) {
    for (const key of this.cache.keys()) {
      if (key.includes(pattern)) {
        this.cache.delete(key);
        this.ttl.delete(key);
      }
    }
  }
}

// Middleware для кэширования запросов
const queryCache = new QueryCache();

const queryCacheMiddleware = (ttl = 300) => {
  return async (req, res, next) => {
    const cacheKey = `query:${req.originalUrl}:${JSON.stringify(req.query)}`;
    
    const cached = queryCache.get(cacheKey);
    if (cached) {
      return res.json(cached);
    }
    
    const originalJson = res.json;
    res.json = function(data) {
      queryCache.set(cacheKey, data, ttl);
      originalJson.call(this, data);
    };
    
    next();
  };
};
```

## CDN и статические ресурсы

### 1. Оптимизация статических файлов

#### Сжатие и минификация
```javascript
// static-optimization.js
const compression = require('compression');
const express = require('express');
const path = require('path');

// Middleware для сжатия
app.use(compression({
  level: 6,
  threshold: 1024,
  filter: (req, res) => {
    if (req.headers['x-no-compression']) {
      return false;
    }
    return compression.filter(req, res);
  }
}));

// Оптимизация изображений
const sharp = require('sharp');

class ImageOptimizer {
  static async optimizeImage(inputPath, outputPath, options = {}) {
    const {
      width = 800,
      height = 600,
      quality = 80,
      format = 'webp'
    } = options;
    
    await sharp(inputPath)
      .resize(width, height, { fit: 'inside', withoutEnlargement: true })
      .webp({ quality })
      .toFile(outputPath);
  }
  
  static async generateResponsiveImages(inputPath, outputDir) {
    const sizes = [320, 640, 1024, 1920];
    const formats = ['webp', 'jpeg'];
    
    for (const size of sizes) {
      for (const format of formats) {
        const outputPath = path.join(outputDir, `${size}.${format}`);
        await this.optimizeImage(inputPath, outputPath, {
          width: size,
          format: format
        });
      }
    }
  }
}
```

#### Кэширование статических ресурсов
```javascript
// static-cache.js
const express = require('express');
const path = require('path');

// Настройка кэширования статических файлов
app.use('/static', express.static(path.join(__dirname, 'public'), {
  maxAge: '1y', // Кэширование на 1 год
  etag: true,
  lastModified: true,
  setHeaders: (res, path) => {
    if (path.endsWith('.css') || path.endsWith('.js')) {
      res.setHeader('Cache-Control', 'public, max-age=31536000');
    }
    if (path.endsWith('.html')) {
      res.setHeader('Cache-Control', 'public, max-age=3600');
    }
  }
}));
```

### 2. CDN интеграция

#### CloudFlare интеграция
```javascript
// cdn-config.js
const cloudflare = require('cloudflare');

class CDNManager {
  constructor(apiToken, zoneId) {
    this.cf = cloudflare({
      token: apiToken
    });
    this.zoneId = zoneId;
  }
  
  async purgeCache(urls) {
    try {
      const result = await this.cf.zones.purgeCache(this.zoneId, {
        files: urls
      });
      return result;
    } catch (error) {
      console.error('CDN purge error:', error);
      throw error;
    }
  }
  
  async purgeAll() {
    try {
      const result = await this.cf.zones.purgeCache(this.zoneId, {
        purge_everything: true
      });
      return result;
    } catch (error) {
      console.error('CDN purge all error:', error);
      throw error;
    }
  }
}
```

## Оптимизация кода

### 1. Асинхронное программирование

#### Promise оптимизация
```javascript
// promise-optimization.js
class PromiseOptimizer {
  // Параллельное выполнение независимых операций
  static async parallelOperations(operations) {
    try {
      const results = await Promise.all(operations);
      return results;
    } catch (error) {
      console.error('Parallel operations error:', error);
      throw error;
    }
  }
  
  // Параллельное выполнение с ограничением
  static async parallelWithLimit(operations, limit = 5) {
    const results = [];
    const executing = [];
    
    for (const operation of operations) {
      const promise = operation().then(result => {
        results.push(result);
        executing.splice(executing.indexOf(promise), 1);
      });
      
      executing.push(promise);
      
      if (executing.length >= limit) {
        await Promise.race(executing);
      }
    }
    
    await Promise.all(executing);
    return results;
  }
  
  // Кэширование промисов
  static createCachedPromise(fn, ttl = 300000) {
    const cache = new Map();
    
    return async (...args) => {
      const key = JSON.stringify(args);
      const cached = cache.get(key);
      
      if (cached && Date.now() - cached.timestamp < ttl) {
        return cached.value;
      }
      
      const result = await fn(...args);
      cache.set(key, {
        value: result,
        timestamp: Date.now()
      });
      
      return result;
    };
  }
}
```

#### Stream обработка
```javascript
// stream-optimization.js
const { Transform, pipeline } = require('stream');
const { promisify } = require('util');
const pipelineAsync = promisify(pipeline);

class StreamProcessor {
  static createTransformStream(transformFn) {
    return new Transform({
      objectMode: true,
      transform(chunk, encoding, callback) {
        try {
          const result = transformFn(chunk);
          callback(null, result);
        } catch (error) {
          callback(error);
        }
      }
    });
  }
  
  static async processLargeDataset(inputStream, transformFn, outputStream) {
    const transform = this.createTransformStream(transformFn);
    
    await pipelineAsync(
      inputStream,
      transform,
      outputStream
    );
  }
}
```

### 2. Алгоритмическая оптимизация

#### Эффективные алгоритмы
```javascript
// algorithm-optimization.js
class AlgorithmOptimizer {
  // Бинарный поиск для отсортированных массивов
  static binarySearch(arr, target) {
    let left = 0;
    let right = arr.length - 1;
    
    while (left <= right) {
      const mid = Math.floor((left + right) / 2);
      
      if (arr[mid] === target) {
        return mid;
      } else if (arr[mid] < target) {
        left = mid + 1;
      } else {
        right = mid - 1;
      }
    }
    
    return -1;
  }
  
  // Мемоизация для дорогих вычислений
  static memoize(fn) {
    const cache = new Map();
    
    return function(...args) {
      const key = JSON.stringify(args);
      
      if (cache.has(key)) {
        return cache.get(key);
      }
      
      const result = fn.apply(this, args);
      cache.set(key, result);
      return result;
    };
  }
  
  // Дебаунсинг для частых вызовов
  static debounce(func, wait) {
    let timeout;
    
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout);
        func(...args);
      };
      
      clearTimeout(timeout);
      timeout = setTimeout(later, wait);
    };
  }
}
```

## Масштабирование

### 1. Горизонтальное масштабирование

#### Load Balancer конфигурация
```nginx
# nginx.conf
upstream backend {
    least_conn;
    server app1:3000 weight=3;
    server app2:3000 weight=3;
    server app3:3000 weight=2;
    
    keepalive 32;
}

server {
    listen 80;
    server_name api.rechain-dao.com;
    
    location / {
        proxy_pass http://backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
        
        # Таймауты
        proxy_connect_timeout 5s;
        proxy_send_timeout 10s;
        proxy_read_timeout 10s;
    }
}
```

#### Кластеризация Node.js
```javascript
// cluster.js
const cluster = require('cluster');
const numCPUs = require('os').cpus().length;

if (cluster.isMaster) {
  console.log(`Master ${process.pid} is running`);
  
  // Fork workers
  for (let i = 0; i < numCPUs; i++) {
    cluster.fork();
  }
  
  cluster.on('exit', (worker, code, signal) => {
    console.log(`Worker ${worker.process.pid} died`);
    cluster.fork(); // Restart worker
  });
} else {
  // Worker process
  require('./app.js');
  console.log(`Worker ${process.pid} started`);
}
```

### 2. Вертикальное масштабирование

#### Мониторинг ресурсов
```javascript
// resource-monitoring.js
const os = require('os');

class ResourceMonitor {
  constructor() {
    this.metrics = {
      cpu: [],
      memory: [],
      load: []
    };
  }
  
  startMonitoring(interval = 5000) {
    setInterval(() => {
      this.collectMetrics();
    }, interval);
  }
  
  collectMetrics() {
    const cpuUsage = process.cpuUsage();
    const memoryUsage = process.memoryUsage();
    const loadAvg = os.loadavg();
    
    this.metrics.cpu.push({
      timestamp: Date.now(),
      user: cpuUsage.user,
      system: cpuUsage.system
    });
    
    this.metrics.memory.push({
      timestamp: Date.now(),
      rss: memoryUsage.rss,
      heapUsed: memoryUsage.heapUsed,
      heapTotal: memoryUsage.heapTotal,
      external: memoryUsage.external
    });
    
    this.metrics.load.push({
      timestamp: Date.now(),
      load1: loadAvg[0],
      load5: loadAvg[1],
      load15: loadAvg[2]
    });
  }
  
  getResourceUsage() {
    return {
      cpu: this.metrics.cpu[this.metrics.cpu.length - 1],
      memory: this.metrics.memory[this.metrics.memory.length - 1],
      load: this.metrics.load[this.metrics.load.length - 1]
    };
  }
}
```

## Заключение

Это руководство по оптимизации производительности обеспечивает комплексный подход к улучшению производительности платформы REChain DAO. Следуя этим стратегиям и используя рекомендуемые техники, вы можете значительно улучшить производительность вашего приложения.

Помните: оптимизация производительности - это непрерывный процесс, который требует постоянного мониторинга, анализа и улучшения.
