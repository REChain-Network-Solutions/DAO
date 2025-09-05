# Security Hardening Guide

## Overview

This document provides comprehensive security hardening strategies for the REChain DAO platform, including application security, infrastructure security, and compliance measures.

## Table of Contents

1. [Application Security](#application-security)
2. [Infrastructure Security](#infrastructure-security)
3. [Data Protection](#data-protection)
4. [Network Security](#network-security)
5. [Monitoring and Incident Response](#monitoring-and-incident-response)

## Application Security

### Input Validation and Sanitization
```javascript
// Input validation middleware
const validator = require('express-validator');
const { body, validationResult } = validator;

const validateProposal = [
  body('title')
    .trim()
    .isLength({ min: 5, max: 200 })
    .withMessage('Title must be between 5 and 200 characters')
    .escape(),
  body('description')
    .trim()
    .isLength({ min: 10, max: 5000 })
    .withMessage('Description must be between 10 and 5000 characters')
    .escape(),
  body('type')
    .isIn(['governance', 'treasury', 'technical', 'social'])
    .withMessage('Invalid proposal type'),
  (req, res, next) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }
    next();
  }
];

// SQL injection prevention
const mysql = require('mysql2/promise');

const getProposal = async (id) => {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  });
  
  // Use parameterized queries
  const [rows] = await connection.execute(
    'SELECT * FROM proposals WHERE id = ?',
    [id]
  );
  
  await connection.end();
  return rows[0];
};
```

### Authentication and Authorization
```javascript
// JWT authentication
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

class AuthService {
  async hashPassword(password) {
    const saltRounds = 12;
    return await bcrypt.hash(password, saltRounds);
  }
  
  async verifyPassword(password, hash) {
    return await bcrypt.compare(password, hash);
  }
  
  generateToken(user) {
    return jwt.sign(
      { 
        userId: user.id, 
        email: user.email,
        role: user.role 
      },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );
  }
  
  verifyToken(token) {
    try {
      return jwt.verify(token, process.env.JWT_SECRET);
    } catch (error) {
      throw new Error('Invalid token');
    }
  }
}

// Role-based access control
const authorize = (roles) => {
  return (req, res, next) => {
    if (!req.user) {
      return res.status(401).json({ error: 'Authentication required' });
    }
    
    if (!roles.includes(req.user.role)) {
      return res.status(403).json({ error: 'Insufficient permissions' });
    }
    
    next();
  };
};

// Usage
app.get('/api/admin/users', 
  authenticateToken, 
  authorize(['admin', 'moderator']), 
  getUsers
);
```

### Rate Limiting and DDoS Protection
```javascript
const rateLimit = require('express-rate-limit');
const slowDown = require('express-slow-down');

// General rate limiting
const generalLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
  message: 'Too many requests from this IP',
  standardHeaders: true,
  legacyHeaders: false,
});

// Strict rate limiting for sensitive endpoints
const strictLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 5,
  message: 'Too many attempts, please try again later',
  skipSuccessfulRequests: true,
});

// Slow down after multiple requests
const speedLimiter = slowDown({
  windowMs: 15 * 60 * 1000,
  delayAfter: 50,
  delayMs: 500,
});

app.use('/api/', generalLimiter);
app.use('/api/auth/', strictLimiter);
app.use('/api/', speedLimiter);
```

## Infrastructure Security

### Container Security
```dockerfile
# Secure Dockerfile
FROM node:18-alpine AS builder

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Install security updates
RUN apk update && apk upgrade

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy application code
COPY --chown=nextjs:nodejs . .

# Build application
RUN npm run build

# Production stage
FROM node:18-alpine AS production

# Install security updates
RUN apk update && apk upgrade

# Create non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Set working directory
WORKDIR /app

# Copy built application
COPY --from=builder --chown=nextjs:nodejs /app/dist ./dist
COPY --from=builder --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nextjs:nodejs /app/package*.json ./

# Switch to non-root user
USER nextjs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

# Start application
CMD ["npm", "start"]
```

### Kubernetes Security
```yaml
# Security context
apiVersion: apps/v1
kind: Deployment
metadata:
  name: rechain-dao-app
spec:
  template:
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1001
        fsGroup: 1001
      containers:
      - name: app
        image: rechain-dao:latest
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
          runAsNonRoot: true
          runAsUser: 1001
          capabilities:
            drop:
            - ALL
        resources:
          limits:
            memory: "512Mi"
            cpu: "500m"
          requests:
            memory: "256Mi"
            cpu: "250m"
        volumeMounts:
        - name: tmp
          mountPath: /tmp
        - name: logs
          mountPath: /app/logs
      volumes:
      - name: tmp
        emptyDir: {}
      - name: logs
        emptyDir: {}
```

### Network Security
```yaml
# Network policies
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: rechain-dao-network-policy
spec:
  podSelector:
    matchLabels:
      app: rechain-dao-app
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    ports:
    - protocol: TCP
      port: 3000
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: rechain-dao
    ports:
    - protocol: TCP
      port: 3306
    - protocol: TCP
      port: 6379
```

## Data Protection

### Encryption at Rest
```javascript
// Database encryption
const crypto = require('crypto');

class EncryptionService {
  constructor() {
    this.algorithm = 'aes-256-gcm';
    this.key = crypto.scryptSync(process.env.ENCRYPTION_KEY, 'salt', 32);
  }
  
  encrypt(text) {
    const iv = crypto.randomBytes(16);
    const cipher = crypto.createCipher(this.algorithm, this.key);
    cipher.setAAD(Buffer.from('rechain-dao', 'utf8'));
    
    let encrypted = cipher.update(text, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    
    const authTag = cipher.getAuthTag();
    
    return {
      encrypted,
      iv: iv.toString('hex'),
      authTag: authTag.toString('hex')
    };
  }
  
  decrypt(encryptedData) {
    const decipher = crypto.createDecipher(
      this.algorithm, 
      Buffer.from(encryptedData.iv, 'hex')
    );
    
    decipher.setAAD(Buffer.from('rechain-dao', 'utf8'));
    decipher.setAuthTag(Buffer.from(encryptedData.authTag, 'hex'));
    
    let decrypted = decipher.update(encryptedData.encrypted, 'hex', 'utf8');
    decrypted += decipher.final('utf8');
    
    return decrypted;
  }
}
```

### Data Masking
```javascript
// PII data masking
class DataMaskingService {
  maskEmail(email) {
    const [local, domain] = email.split('@');
    const maskedLocal = local.charAt(0) + '*'.repeat(local.length - 2) + local.charAt(local.length - 1);
    return `${maskedLocal}@${domain}`;
  }
  
  maskPhone(phone) {
    return phone.replace(/(\d{3})\d{4}(\d{4})/, '$1****$2');
  }
  
  maskCreditCard(cardNumber) {
    return cardNumber.replace(/(\d{4})\d{8}(\d{4})/, '$1********$2');
  }
  
  maskSensitiveData(data) {
    const masked = { ...data };
    
    if (masked.email) {
      masked.email = this.maskEmail(masked.email);
    }
    
    if (masked.phone) {
      masked.phone = this.maskPhone(masked.phone);
    }
    
    return masked;
  }
}
```

## Network Security

### SSL/TLS Configuration
```nginx
# Nginx SSL configuration
server {
    listen 443 ssl http2;
    server_name api.rechain-dao.com;
    
    # SSL configuration
    ssl_certificate /etc/ssl/certs/api.rechain-dao.com.crt;
    ssl_certificate_key /etc/ssl/private/api.rechain-dao.com.key;
    
    # SSL security
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;
    ssl_session_tickets off;
    
    # HSTS
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    
    # Security headers
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    
    location / {
        proxy_pass http://rechain_dao_backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### Firewall Configuration
```bash
#!/bin/bash
# Firewall setup script

# Enable UFW
ufw --force enable

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow SSH
ufw allow 22/tcp

# Allow HTTP and HTTPS
ufw allow 80/tcp
ufw allow 443/tcp

# Allow specific ports for services
ufw allow 3000/tcp  # Application
ufw allow 3306/tcp  # MySQL
ufw allow 6379/tcp  # Redis

# Rate limiting
ufw limit ssh

# Logging
ufw logging on

# Show status
ufw status verbose
```

## Monitoring and Incident Response

### Security Monitoring
```javascript
// Security event logging
const winston = require('winston');

const securityLogger = winston.createLogger({
  level: 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'security.log' }),
    new winston.transports.Console()
  ]
});

class SecurityMonitor {
  logLoginAttempt(userId, success, ip) {
    securityLogger.info('Login attempt', {
      userId,
      success,
      ip,
      timestamp: new Date().toISOString()
    });
  }
  
  logSuspiciousActivity(activity, details) {
    securityLogger.warn('Suspicious activity', {
      activity,
      details,
      timestamp: new Date().toISOString()
    });
  }
  
  logSecurityEvent(event, severity, details) {
    securityLogger.error('Security event', {
      event,
      severity,
      details,
      timestamp: new Date().toISOString()
    });
  }
}
```

### Incident Response
```javascript
// Incident response system
class IncidentResponse {
  constructor() {
    this.incidents = new Map();
  }
  
  createIncident(type, severity, description) {
    const incident = {
      id: this.generateIncidentId(),
      type,
      severity,
      description,
      status: 'open',
      createdAt: new Date(),
      updatedAt: new Date()
    };
    
    this.incidents.set(incident.id, incident);
    this.notifySecurityTeam(incident);
    
    return incident;
  }
  
  updateIncident(id, updates) {
    const incident = this.incidents.get(id);
    if (incident) {
      Object.assign(incident, updates);
      incident.updatedAt = new Date();
      this.incidents.set(id, incident);
    }
  }
  
  notifySecurityTeam(incident) {
    // Send notification to security team
    console.log(`Security incident ${incident.id} created: ${incident.description}`);
  }
  
  generateIncidentId() {
    return 'INC-' + Date.now() + '-' + Math.random().toString(36).substr(2, 9);
  }
}
```

## Conclusion

This security hardening guide provides comprehensive strategies for securing the REChain DAO platform. Regular security audits, monitoring, and updates are essential for maintaining a secure environment.

Remember: Security is an ongoing process. Regularly review and update security measures, conduct penetration testing, and stay informed about new security threats and best practices.
