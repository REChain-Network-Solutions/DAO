# Performance Guide

## Overview

This guide provides comprehensive performance optimization strategies for the REChain DAO Platform, including frontend, backend, database, and infrastructure optimizations.

## Table of Contents

1. [Performance Metrics](#performance-metrics)
2. [Frontend Optimization](#frontend-optimization)
3. [Backend Optimization](#backend-optimization)
4. [Database Optimization](#database-optimization)
5. [Infrastructure Optimization](#infrastructure-optimization)
6. [Monitoring & Profiling](#monitoring--profiling)
7. [Performance Testing](#performance-testing)

## Performance Metrics

### Key Performance Indicators

- **Response Time**: < 200ms for API calls
- **Throughput**: > 1000 requests/second
- **Availability**: 99.9% uptime
- **Error Rate**: < 0.1%
- **Database Query Time**: < 50ms
- **Memory Usage**: < 512MB per instance
- **CPU Usage**: < 70% average

### Performance Targets

```javascript
const performanceTargets = {
  api: {
    responseTime: 200, // ms
    throughput: 1000,  // requests/second
    errorRate: 0.001   // 0.1%
  },
  database: {
    queryTime: 50,     // ms
    connectionTime: 10, // ms
    lockWaitTime: 5    // ms
  },
  frontend: {
    firstContentfulPaint: 1500, // ms
    largestContentfulPaint: 2500, // ms
    cumulativeLayoutShift: 0.1,
    firstInputDelay: 100 // ms
  }
};
```

## Frontend Optimization

### Code Splitting

```javascript
import React, { Suspense, lazy } from 'react';

// Lazy load components
const Dashboard = lazy(() => import('./components/Dashboard'));
const Proposals = lazy(() => import('./components/Proposals'));
const Voting = lazy(() => import('./components/Voting'));

const App = () => {
  return (
    <Router>
      <Suspense fallback={<LoadingSpinner />}>
        <Routes>
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/proposals" element={<Proposals />} />
          <Route path="/voting" element={<Voting />} />
        </Routes>
      </Suspense>
    </Router>
  );
};
```

### Image Optimization

```javascript
const OptimizedImage = ({ src, alt, width, height, ...props }) => {
  const [imageSrc, setImageSrc] = useState('');
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const img = new Image();
    img.onload = () => {
      setImageSrc(src);
      setIsLoading(false);
    };
    img.src = src;
  }, [src]);

  return (
    <div className="image-container" style={{ width, height }}>
      {isLoading && <div className="image-placeholder">Loading...</div>}
      <img
        src={imageSrc}
        alt={alt}
        width={width}
        height={height}
        loading="lazy"
        decoding="async"
        {...props}
      />
    </div>
  );
};
```

### Bundle Optimization

```javascript
// webpack.config.js
module.exports = {
  optimization: {
    splitChunks: {
      chunks: 'all',
      cacheGroups: {
        vendor: {
          test: /[\\/]node_modules[\\/]/,
          name: 'vendors',
          chunks: 'all',
        },
        common: {
          name: 'common',
          minChunks: 2,
          chunks: 'all',
          enforce: true,
        },
      },
    },
  },
  plugins: [
    new CompressionPlugin({
      algorithm: 'gzip',
      test: /\.(js|css|html|svg)$/,
      threshold: 8192,
      minRatio: 0.8,
    }),
  ],
};
```

## Backend Optimization

### Database Query Optimization

```javascript
class ProposalService {
  async getProposals(filters = {}) {
    return Proposal.find(filters)
      .select('title description status createdAt proposer')
      .populate('proposer', 'firstName lastName')
      .sort({ createdAt: -1 })
      .limit(20)
      .lean(); // Use lean() for better performance
  }

  async getProposalStats() {
    return Proposal.aggregate([
      {
        $group: {
          _id: '$status',
          count: { $sum: 1 },
          avgVotes: { $avg: '$totalVotes' }
        }
      }
    ]);
  }
}
```

### Caching Strategy

```javascript
const redis = require('redis');
const client = redis.createClient();

class CacheService {
  async get(key) {
    try {
      const value = await client.get(key);
      return value ? JSON.parse(value) : null;
    } catch (error) {
      console.error('Cache get error:', error);
      return null;
    }
  }

  async set(key, value, ttl = 3600) {
    try {
      await client.setex(key, ttl, JSON.stringify(value));
    } catch (error) {
      console.error('Cache set error:', error);
    }
  }
}

// Cached service methods
class CachedProposalService extends ProposalService {
  constructor() {
    super();
    this.cache = new CacheService();
  }

  async getProposals(filters = {}) {
    const cacheKey = `proposals:${JSON.stringify(filters)}`;
    
    let proposals = await this.cache.get(cacheKey);
    
    if (!proposals) {
      proposals = await super.getProposals(filters);
      await this.cache.set(cacheKey, proposals, 300);
    }
    
    return proposals;
  }
}
```

### Connection Pooling

```javascript
const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
  acquireTimeout: 60000,
  timeout: 60000,
  reconnect: true
});
```

## Database Optimization

### Indexing Strategy

```sql
-- Primary indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_proposals_status ON proposals(status);
CREATE INDEX idx_proposals_created_at ON proposals(created_at);
CREATE INDEX idx_votes_proposal_id ON votes(proposal_id);
CREATE INDEX idx_votes_voter_id ON votes(voter_id);

-- Composite indexes
CREATE INDEX idx_proposals_status_created ON proposals(status, created_at);
CREATE INDEX idx_votes_proposal_voter ON votes(proposal_id, voter_id);

-- Partial indexes
CREATE INDEX idx_proposals_active ON proposals(created_at) 
WHERE status = 'active';
```

### Query Optimization

```sql
-- Optimized query with proper indexing
SELECT 
    p.id,
    p.title,
    p.description,
    p.voting_end,
    COUNT(v.id) as total_votes,
    SUM(CASE WHEN v.vote_type = 'yes' THEN 1 ELSE 0 END) as yes_votes,
    SUM(CASE WHEN v.vote_type = 'no' THEN 1 ELSE 0 END) as no_votes
FROM proposals p
LEFT JOIN votes v ON p.id = v.proposal_id
WHERE p.status = 'active'
    AND p.voting_end > NOW()
GROUP BY p.id, p.title, p.description, p.voting_end
ORDER BY p.voting_end ASC;
```

### Database Configuration

```ini
# my.cnf
[mysqld]
# Performance settings
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT

# Query cache
query_cache_type = 1
query_cache_size = 64M
query_cache_limit = 2M

# Connection settings
max_connections = 200
max_connect_errors = 1000
connect_timeout = 10
wait_timeout = 28800

# Slow query log
slow_query_log = 1
slow_query_log_file = /var/log/mysql/slow.log
long_query_time = 2
```

## Infrastructure Optimization

### Load Balancing

```nginx
upstream rechain_dao_backend {
    least_conn;
    server app1:3000 weight=3 max_fails=3 fail_timeout=30s;
    server app2:3000 weight=3 max_fails=3 fail_timeout=30s;
    server app3:3000 weight=2 max_fails=3 fail_timeout=30s;
    
    keepalive 32;
    keepalive_requests 100;
    keepalive_timeout 60s;
}

server {
    listen 80;
    server_name api.rechain-dao.com;
    
    location / {
        proxy_pass http://rechain_dao_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Connection optimization
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        
        # Timeouts
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
        
        # Buffering
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
        proxy_busy_buffers_size 8k;
    }
}
```

### CDN Configuration

```javascript
const cdnConfig = {
  staticAssets: {
    baseUrl: 'https://cdn.rechain-dao.com',
    version: process.env.ASSETS_VERSION,
    cacheControl: 'public, max-age=31536000, immutable'
  },
  
  apiResponses: {
    baseUrl: 'https://api.rechain-dao.com',
    cacheControl: 'public, max-age=300'
  }
};

const getCDNUrl = (path, type = 'static') => {
  const config = cdnConfig[type === 'static' ? 'staticAssets' : 'apiResponses'];
  return `${config.baseUrl}/${path}?v=${config.version}`;
};
```

## Monitoring & Profiling

### Performance Monitoring

```javascript
const performanceMonitor = {
  measureTime: (fn, name) => {
    const start = performance.now();
    const result = fn();
    const end = performance.now();
    
    console.log(`${name} took ${end - start} milliseconds`);
    return result;
  },
  
  measureAsyncTime: async (fn, name) => {
    const start = performance.now();
    const result = await fn();
    const end = performance.now();
    
    console.log(`${name} took ${end - start} milliseconds`);
    return result;
  },
  
  getMemoryUsage: () => {
    const usage = process.memoryUsage();
    return {
      rss: Math.round(usage.rss / 1024 / 1024) + ' MB',
      heapTotal: Math.round(usage.heapTotal / 1024 / 1024) + ' MB',
      heapUsed: Math.round(usage.heapUsed / 1024 / 1024) + ' MB',
      external: Math.round(usage.external / 1024 / 1024) + ' MB'
    };
  }
};
```

### Application Performance Monitoring

```javascript
const apm = require('elastic-apm-node').start({
  serviceName: 'rechain-dao',
  serverUrl: process.env.APM_SERVER_URL,
  secretToken: process.env.APM_SECRET_TOKEN,
  environment: process.env.NODE_ENV
});

const metrics = {
  requestDuration: new apm.Metric('request.duration', 'histogram'),
  dbQueryDuration: new apm.Metric('db.query.duration', 'histogram'),
  cacheHitRate: new apm.Metric('cache.hit.rate', 'gauge'),
  errorRate: new apm.Metric('error.rate', 'counter')
};
```

## Performance Testing

### Load Testing Script

```javascript
// k6-load-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

const errorRate = new Rate('errors');

export const options = {
  stages: [
    { duration: '2m', target: 100 },
    { duration: '5m', target: 100 },
    { duration: '2m', target: 200 },
    { duration: '5m', target: 200 },
    { duration: '2m', target: 0 },
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],
    http_req_failed: ['rate<0.1'],
    errors: ['rate<0.1'],
  },
};

const BASE_URL = 'http://localhost:3000';

export function setup() {
  const loginResponse = http.post(`${BASE_URL}/api/auth/login`, {
    email: 'test@example.com',
    password: 'password123'
  });
  
  return {
    authToken: loginResponse.json('token')
  };
}

export default function(data) {
  const params = {
    headers: {
      'Authorization': `Bearer ${data.authToken}`,
      'Content-Type': 'application/json',
    },
  };

  const proposalsResponse = http.get(`${BASE_URL}/api/proposals`, params);
  check(proposalsResponse, {
    'proposals status is 200': (r) => r.status === 200,
    'proposals response time < 500ms': (r) => r.timings.duration < 500,
  });
  errorRate.add(proposalsResponse.status !== 200);

  sleep(1);
}
```

### Performance Benchmarks

```javascript
const benchmarks = {
  apiResponseTime: {
    excellent: 100,
    good: 300,
    acceptable: 500,
    poor: 1000
  },
  
  dbQueryTime: {
    excellent: 10,
    good: 50,
    acceptable: 100,
    poor: 500
  },
  
  memoryUsage: {
    excellent: 100,
    good: 200,
    acceptable: 500,
    poor: 1000
  }
};

const calculatePerformanceScore = (metrics) => {
  let score = 100;
  
  if (metrics.apiResponseTime > benchmarks.apiResponseTime.poor) {
    score -= 30;
  } else if (metrics.apiResponseTime > benchmarks.apiResponseTime.acceptable) {
    score -= 20;
  } else if (metrics.apiResponseTime > benchmarks.apiResponseTime.good) {
    score -= 10;
  }
  
  return Math.max(0, score);
};
```

## Conclusion

This performance guide provides comprehensive strategies for optimizing the REChain DAO Platform. Regular monitoring, profiling, and testing are essential for maintaining optimal performance.

For additional support, please refer to our [documentation](docs/) or contact our [support team](mailto:support@rechain-dao.com).
