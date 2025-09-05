# CI/CD Pipelines

## Overview

This document provides comprehensive CI/CD pipeline configurations for the REChain DAO platform, including GitHub Actions, GitLab CI, and Jenkins pipelines for automated testing, building, and deployment.

## Table of Contents

1. [GitHub Actions](#github-actions)
2. [GitLab CI](#gitlab-ci)
3. [Jenkins Pipelines](#jenkins-pipelines)
4. [Testing Strategies](#testing-strategies)
5. [Deployment Strategies](#deployment-strategies)
6. [Security Integration](#security-integration)

## GitHub Actions

### Main Workflow
```yaml
# .github/workflows/main.yml
name: Main CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

env:
  NODE_VERSION: '18'
  PHP_VERSION: '8.1'

jobs:
  test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node-version: [16, 18, 20]
        php-version: [8.0, 8.1, 8.2]
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: ${{ matrix.node-version }}
        cache: 'npm'
    
    - name: Setup PHP
      uses: shivammathur/setup-php@v2
      with:
        php-version: ${{ matrix.php-version }}
        extensions: mbstring, xml, ctype, iconv, intl, pdo_mysql, dom, filter, gd, json, libxml, openssl, pcre, pdo, session, simplexml, tokenizer, xmlreader, xmlwriter, zip, zlib
        coverage: xdebug
    
    - name: Install dependencies
      run: |
        npm ci
        composer install --no-dev --optimize-autoloader
    
    - name: Run tests
      run: |
        npm run test
        composer test
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info

  build:
    needs: test
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'
    
    - name: Setup PHP
      uses: shivammathur/setup-php@v2
      with:
        php-version: ${{ env.PHP_VERSION }}
        extensions: mbstring, xml, ctype, iconv, intl, pdo_mysql, dom, filter, gd, json, libxml, openssl, pcre, pdo, session, simplexml, tokenizer, xmlreader, xmlwriter, zip, zlib
    
    - name: Install dependencies
      run: |
        npm ci
        composer install --no-dev --optimize-autoloader
    
    - name: Build application
      run: |
        npm run build
        composer dump-autoload --optimize
    
    - name: Build Docker image
      run: |
        docker build -t rechain-dao:${{ github.sha }} .
        docker tag rechain-dao:${{ github.sha }} rechain-dao:latest
    
    - name: Push to registry
      if: github.ref == 'refs/heads/main'
      run: |
        echo ${{ secrets.DOCKER_PASSWORD }} | docker login -u ${{ secrets.DOCKER_USERNAME }} --password-stdin
        docker push rechain-dao:${{ github.sha }}
        docker push rechain-dao:latest

  deploy-staging:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/develop'
    
    steps:
    - name: Deploy to staging
      uses: appleboy/ssh-action@v0.1.5
      with:
        host: ${{ secrets.STAGING_HOST }}
        username: ${{ secrets.STAGING_USER }}
        key: ${{ secrets.STAGING_SSH_KEY }}
        script: |
          cd /opt/rechain-dao
          docker-compose -f docker-compose.staging.yml pull
          docker-compose -f docker-compose.staging.yml up -d
          docker system prune -f

  deploy-production:
    needs: build
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    
    steps:
    - name: Deploy to production
      uses: appleboy/ssh-action@v0.1.5
      with:
        host: ${{ secrets.PRODUCTION_HOST }}
        username: ${{ secrets.PRODUCTION_USER }}
        key: ${{ secrets.PRODUCTION_SSH_KEY }}
        script: |
          cd /opt/rechain-dao
          docker-compose -f docker-compose.prod.yml pull
          docker-compose -f docker-compose.prod.yml up -d
          docker system prune -f
```

### Security Workflow
```yaml
# .github/workflows/security.yml
name: Security Scan

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]
  schedule:
    - cron: '0 2 * * 1' # Weekly on Monday at 2 AM

jobs:
  security-scan:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Run Trivy vulnerability scanner
      uses: aquasecurity/trivy-action@master
      with:
        scan-type: 'fs'
        scan-ref: '.'
        format: 'sarif'
        output: 'trivy-results.sarif'
    
    - name: Upload Trivy scan results
      uses: github/codeql-action/upload-sarif@v2
      with:
        sarif_file: 'trivy-results.sarif'
    
    - name: Run Snyk to check for vulnerabilities
      uses: snyk/actions/node@master
      env:
        SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
      with:
        args: --severity-threshold=high
    
    - name: Run CodeQL Analysis
      uses: github/codeql-action/analyze@v2
      with:
        languages: javascript, php
```

### Performance Workflow
```yaml
# .github/workflows/performance.yml
name: Performance Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  performance-test:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Start application
      run: |
        npm run build
        npm start &
        sleep 30
    
    - name: Run Lighthouse CI
      uses: treosh/lighthouse-ci-action@v9
      with:
        configPath: './lighthouse.config.js'
        uploadArtifacts: true
        temporaryPublicStorage: true
    
    - name: Run K6 performance tests
      run: |
        docker run --rm -v $(pwd):/app loadimpact/k6 run /app/tests/performance/load-test.js
```

## GitLab CI

### Main Pipeline
```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - security
  - deploy

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

services:
  - docker:dind

test:
  stage: test
  image: node:18-alpine
  before_script:
    - apk add --no-cache python3 make g++
    - npm ci
    - composer install --no-dev --optimize-autoloader
  script:
    - npm run test
    - composer test
  coverage: '/Lines\s*:\s*(\d+\.\d+)%/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

build:
  stage: build
  image: docker:latest
  services:
    - docker:dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA $CI_REGISTRY_IMAGE:latest
    - docker push $CI_REGISTRY_IMAGE:latest
  only:
    - main
    - develop

security:
  stage: security
  image: docker:latest
  services:
    - docker:dind
  script:
    - docker run --rm -v $(pwd):/app aquasec/trivy fs /app
    - docker run --rm -v $(pwd):/app snyk/snyk:docker test /app

deploy-staging:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - eval $(ssh-agent -s)
    - echo "$STAGING_SSH_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
  script:
    - ssh -o StrictHostKeyChecking=no $STAGING_USER@$STAGING_HOST "cd /opt/rechain-dao && docker-compose -f docker-compose.staging.yml pull && docker-compose -f docker-compose.staging.yml up -d"
  only:
    - develop

deploy-production:
  stage: deploy
  image: alpine:latest
  before_script:
    - apk add --no-cache openssh-client
    - eval $(ssh-agent -s)
    - echo "$PRODUCTION_SSH_KEY" | tr -d '\r' | ssh-add -
    - mkdir -p ~/.ssh
    - chmod 700 ~/.ssh
  script:
    - ssh -o StrictHostKeyChecking=no $PRODUCTION_USER@$PRODUCTION_HOST "cd /opt/rechain-dao && docker-compose -f docker-compose.prod.yml pull && docker-compose -f docker-compose.prod.yml up -d"
  only:
    - main
  when: manual
```

## Jenkins Pipelines

### Main Pipeline
```groovy
// Jenkinsfile
pipeline {
    agent any
    
    environment {
        NODE_VERSION = '18'
        PHP_VERSION = '8.1'
        DOCKER_REGISTRY = 'registry.example.com'
        IMAGE_NAME = 'rechain-dao'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Test') {
            parallel {
                stage('Node.js Tests') {
                    steps {
                        sh 'npm ci'
                        sh 'npm run test'
                    }
                    post {
                        always {
                            publishHTML([
                                allowMissing: false,
                                alwaysLinkToLastBuild: true,
                                keepAll: true,
                                reportDir: 'coverage',
                                reportFiles: 'index.html',
                                reportName: 'Coverage Report'
                            ])
                        }
                    }
                }
                
                stage('PHP Tests') {
                    steps {
                        sh 'composer install --no-dev --optimize-autoloader'
                        sh 'composer test'
                    }
                }
                
                stage('Security Scan') {
                    steps {
                        sh 'npm audit --audit-level high'
                        sh 'composer audit'
                    }
                }
            }
        }
        
        stage('Build') {
            steps {
                sh 'npm run build'
                sh 'docker build -t ${IMAGE_NAME}:${BUILD_NUMBER} .'
                sh 'docker tag ${IMAGE_NAME}:${BUILD_NUMBER} ${IMAGE_NAME}:latest'
            }
        }
        
        stage('Push') {
            steps {
                sh 'docker push ${IMAGE_NAME}:${BUILD_NUMBER}'
                sh 'docker push ${IMAGE_NAME}:latest'
            }
        }
        
        stage('Deploy Staging') {
            when {
                branch 'develop'
            }
            steps {
                sh 'ssh staging-server "cd /opt/rechain-dao && docker-compose -f docker-compose.staging.yml pull && docker-compose -f docker-compose.staging.yml up -d"'
            }
        }
        
        stage('Deploy Production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'
                sh 'ssh production-server "cd /opt/rechain-dao && docker-compose -f docker-compose.prod.yml pull && docker-compose -f docker-compose.prod.yml up -d"'
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            emailext (
                subject: "Build Successful: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "Build ${env.BUILD_NUMBER} completed successfully.",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
        failure {
            emailext (
                subject: "Build Failed: ${env.JOB_NAME} - ${env.BUILD_NUMBER}",
                body: "Build ${env.BUILD_NUMBER} failed. Please check the console output.",
                to: "${env.CHANGE_AUTHOR_EMAIL}"
            )
        }
    }
}
```

### Multi-Branch Pipeline
```groovy
// Jenkinsfile.multibranch
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh 'npm ci'
                sh 'composer install --no-dev --optimize-autoloader'
                sh 'npm run build'
            }
        }
        
        stage('Test') {
            steps {
                sh 'npm run test'
                sh 'composer test'
            }
        }
        
        stage('Security') {
            steps {
                sh 'npm audit --audit-level high'
                sh 'composer audit'
            }
        }
        
        stage('Docker Build') {
            steps {
                sh 'docker build -t rechain-dao:${BRANCH_NAME}-${BUILD_NUMBER} .'
            }
        }
        
        stage('Deploy') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                }
            }
            steps {
                script {
                    if (env.BRANCH_NAME == 'main') {
                        sh 'ssh production-server "cd /opt/rechain-dao && docker-compose -f docker-compose.prod.yml up -d"'
                    } else if (env.BRANCH_NAME == 'develop') {
                        sh 'ssh staging-server "cd /opt/rechain-dao && docker-compose -f docker-compose.staging.yml up -d"'
                    }
                }
            }
        }
    }
}
```

## Testing Strategies

### Unit Testing
```javascript
// tests/unit/user.test.js
const { User } = require('../../src/models/User');
const { expect } = require('chai');

describe('User Model', () => {
    describe('createUser', () => {
        it('should create a user with valid data', async () => {
            const userData = {
                username: 'testuser',
                email: 'test@example.com',
                password: 'password123'
            };
            
            const user = await User.create(userData);
            
            expect(user).to.have.property('id');
            expect(user.username).to.equal(userData.username);
            expect(user.email).to.equal(userData.email);
        });
        
        it('should throw error for invalid email', async () => {
            const userData = {
                username: 'testuser',
                email: 'invalid-email',
                password: 'password123'
            };
            
            try {
                await User.create(userData);
                expect.fail('Should have thrown an error');
            } catch (error) {
                expect(error.message).to.include('Invalid email');
            }
        });
    });
});
```

### Integration Testing
```javascript
// tests/integration/api.test.js
const request = require('supertest');
const app = require('../../src/app');
const { expect } = require('chai');

describe('API Integration Tests', () => {
    describe('POST /api/users', () => {
        it('should create a new user', async () => {
            const userData = {
                username: 'testuser',
                email: 'test@example.com',
                password: 'password123'
            };
            
            const response = await request(app)
                .post('/api/users')
                .send(userData)
                .expect(201);
            
            expect(response.body).to.have.property('id');
            expect(response.body.username).to.equal(userData.username);
        });
        
        it('should return 400 for invalid data', async () => {
            const userData = {
                username: '',
                email: 'invalid-email',
                password: '123'
            };
            
            await request(app)
                .post('/api/users')
                .send(userData)
                .expect(400);
        });
    });
});
```

### End-to-End Testing
```javascript
// tests/e2e/user-flow.test.js
const { Builder, By, until } = require('selenium-webdriver');
const { expect } = require('chai');

describe('User Flow E2E Tests', () => {
    let driver;
    
    before(async () => {
        driver = await new Builder().forBrowser('chrome').build();
    });
    
    after(async () => {
        await driver.quit();
    });
    
    it('should complete user registration flow', async () => {
        await driver.get('http://localhost:8000/register');
        
        await driver.findElement(By.name('username')).sendKeys('testuser');
        await driver.findElement(By.name('email')).sendKeys('test@example.com');
        await driver.findElement(By.name('password')).sendKeys('password123');
        await driver.findElement(By.name('confirmPassword')).sendKeys('password123');
        
        await driver.findElement(By.css('button[type="submit"]')).click();
        
        await driver.wait(until.urlContains('/dashboard'), 5000);
        
        const title = await driver.getTitle();
        expect(title).to.include('Dashboard');
    });
});
```

## Deployment Strategies

### Blue-Green Deployment
```yaml
# blue-green-deployment.yml
version: '3.8'

services:
  app-blue:
    image: rechain-dao:blue
    ports:
      - "8001:8000"
    environment:
      - NODE_ENV=production
    networks:
      - rechain-network

  app-green:
    image: rechain-dao:green
    ports:
      - "8002:8000"
    environment:
      - NODE_ENV=production
    networks:
      - rechain-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - app-blue
      - app-green
    networks:
      - rechain-network

networks:
  rechain-network:
    driver: bridge
```

### Canary Deployment
```yaml
# canary-deployment.yml
version: '3.8'

services:
  app-stable:
    image: rechain-dao:stable
    ports:
      - "8001:8000"
    environment:
      - NODE_ENV=production
    networks:
      - rechain-network
    deploy:
      replicas: 9

  app-canary:
    image: rechain-dao:canary
    ports:
      - "8002:8000"
    environment:
      - NODE_ENV=production
    networks:
      - rechain-network
    deploy:
      replicas: 1

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
    volumes:
      - ./nginx-canary.conf:/etc/nginx/nginx.conf
    depends_on:
      - app-stable
      - app-canary
    networks:
      - rechain-network

networks:
  rechain-network:
    driver: bridge
```

## Security Integration

### SAST Integration
```yaml
# .github/workflows/sast.yml
name: SAST Security Scan

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  sast:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Run CodeQL Analysis
      uses: github/codeql-action/analyze@v2
      with:
        languages: javascript, php
    
    - name: Run Semgrep
      uses: returntocorp/semgrep-action@v1
      with:
        config: >-
          p/security-audit
          p/owasp-top-ten
          p/javascript
          p/php
        generateSarif: "1"
    
    - name: Upload Semgrep results
      uses: github/codeql-action/upload-sarif@v2
      with:
        sarif_file: semgrep.sarif
```

### DAST Integration
```yaml
# .github/workflows/dast.yml
name: DAST Security Scan

on:
  schedule:
    - cron: '0 2 * * 1' # Weekly on Monday at 2 AM

jobs:
  dast:
    runs-on: ubuntu-latest
    
    steps:
    - name: Checkout code
      uses: actions/checkout@v3
    
    - name: Start application
      run: |
        docker-compose -f docker-compose.staging.yml up -d
        sleep 60
    
    - name: Run OWASP ZAP
      uses: zaproxy/action-full-scan@v0.4.0
      with:
        target: 'http://localhost:8000'
        rules_file_name: '.zap/rules.tsv'
        cmd_options: '-a'
    
    - name: Upload ZAP results
      uses: actions/upload-artifact@v3
      with:
        name: zap-results
        path: zap-results/
```

## Conclusion

These CI/CD pipeline configurations provide comprehensive automation for the REChain DAO platform, including testing, building, security scanning, and deployment across different environments.

Remember: Always customize these pipelines based on your specific requirements, security policies, and infrastructure setup. Regularly review and update the configurations to ensure they remain effective and secure.
