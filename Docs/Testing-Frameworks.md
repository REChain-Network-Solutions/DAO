# Testing Frameworks

## Overview

This document provides comprehensive testing frameworks and configurations for the REChain DAO platform, including unit tests, integration tests, end-to-end tests, and performance tests.

## Table of Contents

1. [Unit Testing](#unit-testing)
2. [Integration Testing](#integration-testing)
3. [End-to-End Testing](#end-to-end-testing)
4. [Performance Testing](#performance-testing)
5. [Test Automation](#test-automation)
6. [Test Data Management](#test-data-management)

## Unit Testing

### Jest Configuration
```javascript
// jest.config.js
const { pathsToModuleNameMapper } = require('ts-jest');
const { compilerOptions } = require('./tsconfig.json');

module.exports = {
  preset: 'ts-jest',
  testEnvironment: 'node',
  roots: ['<rootDir>/src', '<rootDir>/tests'],
  testMatch: [
    '**/__tests__/**/*.ts',
    '**/?(*.)+(spec|test).ts'
  ],
  transform: {
    '^.+\\.ts$': 'ts-jest'
  },
  collectCoverageFrom: [
    'src/**/*.ts',
    '!src/**/*.d.ts',
    '!src/**/*.test.ts',
    '!src/**/*.spec.ts',
    '!src/**/index.ts'
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html', 'json'],
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  },
  setupFilesAfterEnv: ['<rootDir>/tests/setup.ts'],
  testTimeout: 10000,
  verbose: true,
  moduleNameMapping: pathsToModuleNameMapper(compilerOptions.paths, {
    prefix: '<rootDir>/'
  }),
  globals: {
    'ts-jest': {
      tsconfig: 'tsconfig.json'
    }
  }
};
```

### Test Setup
```typescript
// tests/setup.ts
import { config } from 'dotenv';
import { MongoMemoryServer } from 'mongodb-memory-server';
import mongoose from 'mongoose';

// Load test environment variables
config({ path: '.env.test' });

let mongoServer: MongoMemoryServer;

beforeAll(async () => {
  // Start in-memory MongoDB
  mongoServer = await MongoMemoryServer.create();
  const mongoUri = mongoServer.getUri();
  
  // Connect to in-memory database
  await mongoose.connect(mongoUri);
});

afterAll(async () => {
  // Close database connection
  await mongoose.disconnect();
  
  // Stop in-memory MongoDB
  await mongoServer.stop();
});

beforeEach(async () => {
  // Clean database before each test
  const collections = mongoose.connection.collections;
  for (const key in collections) {
    const collection = collections[key];
    await collection.deleteMany({});
  }
});

// Global test utilities
global.testUtils = {
  createUser: async (userData = {}) => {
    const User = require('../src/models/User').default;
    return await User.create({
      email: 'test@example.com',
      password: 'password123',
      ...userData
    });
  },
  
  createProposal: async (proposalData = {}) => {
    const Proposal = require('../src/models/Proposal').default;
    return await Proposal.create({
      title: 'Test Proposal',
      description: 'Test description',
      proposer: '507f1f77bcf86cd799439011',
      ...proposalData
    });
  },
  
  createVote: async (voteData = {}) => {
    const Vote = require('../src/models/Vote').default;
    return await Vote.create({
      proposal: '507f1f77bcf86cd799439011',
      voter: '507f1f77bcf86cd799439012',
      voteType: 'yes',
      ...voteData
    });
  }
};
```

### Unit Test Examples
```typescript
// tests/unit/services/ProposalService.test.ts
import { ProposalService } from '../../../src/services/ProposalService';
import { Proposal } from '../../../src/models/Proposal';
import { User } from '../../../src/models/User';

describe('ProposalService', () => {
  let proposalService: ProposalService;
  let testUser: any;
  let testProposal: any;

  beforeEach(() => {
    proposalService = new ProposalService();
  });

  describe('createProposal', () => {
    it('should create a proposal successfully', async () => {
      // Arrange
      testUser = await global.testUtils.createUser();
      const proposalData = {
        title: 'Test Proposal',
        description: 'Test description',
        proposer: testUser._id
      };

      // Act
      const result = await proposalService.createProposal(proposalData);

      // Assert
      expect(result).toBeDefined();
      expect(result.title).toBe(proposalData.title);
      expect(result.description).toBe(proposalData.description);
      expect(result.proposer).toBe(testUser._id);
    });

    it('should throw error for invalid proposal data', async () => {
      // Arrange
      const invalidData = {
        title: '', // Empty title
        description: 'Test description'
      };

      // Act & Assert
      await expect(proposalService.createProposal(invalidData))
        .rejects
        .toThrow('Title is required');
    });
  });

  describe('getProposals', () => {
    beforeEach(async () => {
      testUser = await global.testUtils.createUser();
      testProposal = await global.testUtils.createProposal({
        proposer: testUser._id
      });
    });

    it('should return all proposals', async () => {
      // Act
      const proposals = await proposalService.getProposals();

      // Assert
      expect(proposals).toHaveLength(1);
      expect(proposals[0].title).toBe(testProposal.title);
    });

    it('should filter proposals by status', async () => {
      // Arrange
      await global.testUtils.createProposal({
        proposer: testUser._id,
        status: 'draft'
      });

      // Act
      const activeProposals = await proposalService.getProposals({ status: 'active' });

      // Assert
      expect(activeProposals).toHaveLength(1);
      expect(activeProposals[0].status).toBe('active');
    });
  });

  describe('voteOnProposal', () => {
    beforeEach(async () => {
      testUser = await global.testUtils.createUser();
      testProposal = await global.testUtils.createProposal({
        proposer: testUser._id
      });
    });

    it('should cast a vote successfully', async () => {
      // Arrange
      const voter = await global.testUtils.createUser();
      const voteData = {
        proposalId: testProposal._id,
        voterId: voter._id,
        voteType: 'yes'
      };

      // Act
      const result = await proposalService.voteOnProposal(voteData);

      // Assert
      expect(result).toBeDefined();
      expect(result.voteType).toBe('yes');
      expect(result.proposal).toBe(testProposal._id);
      expect(result.voter).toBe(voter._id);
    });

    it('should prevent duplicate votes', async () => {
      // Arrange
      const voter = await global.testUtils.createUser();
      const voteData = {
        proposalId: testProposal._id,
        voterId: voter._id,
        voteType: 'yes'
      };

      // Act
      await proposalService.voteOnProposal(voteData);
      
      // Assert
      await expect(proposalService.voteOnProposal(voteData))
        .rejects
        .toThrow('User has already voted on this proposal');
    });
  });
});
```

## Integration Testing

### Integration Test Setup
```typescript
// tests/integration/setup.ts
import request from 'supertest';
import { app } from '../../src/app';
import { connectDB, disconnectDB } from '../../src/config/database';
import { User } from '../../src/models/User';

let authToken: string;
let testUser: any;

export const setupIntegrationTests = async () => {
  // Connect to test database
  await connectDB();
  
  // Create test user and get auth token
  testUser = await User.create({
    email: 'test@example.com',
    password: 'password123',
    firstName: 'Test',
    lastName: 'User'
  });
  
  // Login to get auth token
  const response = await request(app)
    .post('/api/auth/login')
    .send({
      email: 'test@example.com',
      password: 'password123'
    });
  
  authToken = response.body.token;
};

export const cleanupIntegrationTests = async () => {
  // Clean up test data
  await User.deleteMany({});
  
  // Disconnect from database
  await disconnectDB();
};

export { authToken, testUser };
```

### API Integration Tests
```typescript
// tests/integration/api/proposals.test.ts
import request from 'supertest';
import { app } from '../../../src/app';
import { setupIntegrationTests, cleanupIntegrationTests, authToken } from '../setup';

describe('Proposals API', () => {
  beforeAll(async () => {
    await setupIntegrationTests();
  });

  afterAll(async () => {
    await cleanupIntegrationTests();
  });

  describe('POST /api/proposals', () => {
    it('should create a proposal with valid data', async () => {
      const proposalData = {
        title: 'Test Proposal',
        description: 'Test description',
        type: 'governance'
      };

      const response = await request(app)
        .post('/api/proposals')
        .set('Authorization', `Bearer ${authToken}`)
        .send(proposalData)
        .expect(201);

      expect(response.body).toMatchObject({
        title: proposalData.title,
        description: proposalData.description,
        type: proposalData.type,
        status: 'draft'
      });
    });

    it('should return 401 without authentication', async () => {
      const proposalData = {
        title: 'Test Proposal',
        description: 'Test description'
      };

      await request(app)
        .post('/api/proposals')
        .send(proposalData)
        .expect(401);
    });

    it('should return 400 with invalid data', async () => {
      const invalidData = {
        title: '', // Empty title
        description: 'Test description'
      };

      await request(app)
        .post('/api/proposals')
        .set('Authorization', `Bearer ${authToken}`)
        .send(invalidData)
        .expect(400);
    });
  });

  describe('GET /api/proposals', () => {
    it('should return proposals list', async () => {
      const response = await request(app)
        .get('/api/proposals')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(Array.isArray(response.body)).toBe(true);
    });

    it('should filter proposals by status', async () => {
      const response = await request(app)
        .get('/api/proposals?status=active')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200);

      expect(Array.isArray(response.body)).toBe(true);
    });
  });

  describe('POST /api/proposals/:id/vote', () => {
    let proposalId: string;

    beforeEach(async () => {
      // Create a proposal for voting
      const proposalData = {
        title: 'Voting Test Proposal',
        description: 'Test description',
        type: 'governance'
      };

      const response = await request(app)
        .post('/api/proposals')
        .set('Authorization', `Bearer ${authToken}`)
        .send(proposalData);

      proposalId = response.body._id;
    });

    it('should cast a vote successfully', async () => {
      const voteData = {
        voteType: 'yes',
        reason: 'I support this proposal'
      };

      const response = await request(app)
        .post(`/api/proposals/${proposalId}/vote`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(voteData)
        .expect(201);

      expect(response.body).toMatchObject({
        voteType: 'yes',
        reason: 'I support this proposal'
      });
    });

    it('should prevent duplicate votes', async () => {
      const voteData = {
        voteType: 'yes'
      };

      // First vote
      await request(app)
        .post(`/api/proposals/${proposalId}/vote`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(voteData)
        .expect(201);

      // Second vote should fail
      await request(app)
        .post(`/api/proposals/${proposalId}/vote`)
        .set('Authorization', `Bearer ${authToken}`)
        .send(voteData)
        .expect(400);
    });
  });
});
```

## End-to-End Testing

### Cypress Configuration
```javascript
// cypress.config.js
const { defineConfig } = require('cypress');

module.exports = defineConfig({
  e2e: {
    baseUrl: 'http://localhost:3000',
    supportFile: 'cypress/support/e2e.js',
    specPattern: 'cypress/e2e/**/*.cy.{js,jsx,ts,tsx}',
    viewportWidth: 1280,
    viewportHeight: 720,
    video: true,
    screenshotOnRunFailure: true,
    defaultCommandTimeout: 10000,
    requestTimeout: 10000,
    responseTimeout: 10000,
    setupNodeEvents(on, config) {
      // implement node event listeners here
      on('task', {
        log(message) {
          console.log(message);
          return null;
        },
        table(message) {
          console.table(message);
          return null;
        }
      });
    },
  },
  component: {
    devServer: {
      framework: 'react',
      bundler: 'vite',
    },
    specPattern: 'cypress/component/**/*.cy.{js,jsx,ts,tsx}',
    supportFile: 'cypress/support/component.js',
  },
});
```

### E2E Test Examples
```typescript
// cypress/e2e/proposals.cy.ts
describe('Proposals E2E Tests', () => {
  beforeEach(() => {
    // Visit the application
    cy.visit('/');
    
    // Login
    cy.get('[data-testid="login-email"]').type('test@example.com');
    cy.get('[data-testid="login-password"]').type('password123');
    cy.get('[data-testid="login-submit"]').click();
    
    // Wait for login to complete
    cy.url().should('include', '/dashboard');
  });

  it('should create a new proposal', () => {
    // Navigate to create proposal page
    cy.get('[data-testid="create-proposal-btn"]').click();
    
    // Fill proposal form
    cy.get('[data-testid="proposal-title"]').type('Test E2E Proposal');
    cy.get('[data-testid="proposal-description"]').type('This is a test proposal created during E2E testing');
    cy.get('[data-testid="proposal-type"]').select('governance');
    
    // Submit proposal
    cy.get('[data-testid="proposal-submit"]').click();
    
    // Verify success message
    cy.get('[data-testid="success-message"]').should('contain', 'Proposal created successfully');
    
    // Verify proposal appears in list
    cy.visit('/proposals');
    cy.get('[data-testid="proposal-list"]').should('contain', 'Test E2E Proposal');
  });

  it('should vote on a proposal', () => {
    // Navigate to proposals page
    cy.visit('/proposals');
    
    // Click on first proposal
    cy.get('[data-testid="proposal-item"]').first().click();
    
    // Vote yes
    cy.get('[data-testid="vote-yes-btn"]').click();
    cy.get('[data-testid="vote-reason"]').type('I support this proposal');
    cy.get('[data-testid="vote-submit"]').click();
    
    // Verify vote was cast
    cy.get('[data-testid="vote-success"]').should('contain', 'Vote cast successfully');
    cy.get('[data-testid="vote-yes-btn"]').should('have.class', 'voted');
  });

  it('should display proposal statistics', () => {
    // Navigate to proposals page
    cy.visit('/proposals');
    
    // Click on first proposal
    cy.get('[data-testid="proposal-item"]').first().click();
    
    // Check statistics are displayed
    cy.get('[data-testid="proposal-stats"]').should('be.visible');
    cy.get('[data-testid="yes-votes"]').should('contain', 'Yes:');
    cy.get('[data-testid="no-votes"]').should('contain', 'No:');
    cy.get('[data-testid="abstain-votes"]').should('contain', 'Abstain:');
  });
});
```

### Component Tests
```typescript
// cypress/component/ProposalCard.cy.tsx
import React from 'react';
import { ProposalCard } from '../../src/components/ProposalCard';

describe('ProposalCard Component', () => {
  const mockProposal = {
    id: '1',
    title: 'Test Proposal',
    description: 'Test description',
    status: 'active',
    type: 'governance',
    proposer: 'Test User',
    createdAt: '2024-01-01T00:00:00Z',
    votingEnd: '2024-01-08T00:00:00Z',
    yesVotes: 10,
    noVotes: 5,
    abstainVotes: 2
  };

  it('should render proposal information', () => {
    cy.mount(<ProposalCard proposal={mockProposal} />);
    
    cy.get('[data-testid="proposal-title"]').should('contain', 'Test Proposal');
    cy.get('[data-testid="proposal-description"]').should('contain', 'Test description');
    cy.get('[data-testid="proposal-status"]').should('contain', 'active');
    cy.get('[data-testid="proposal-type"]').should('contain', 'governance');
  });

  it('should display voting statistics', () => {
    cy.mount(<ProposalCard proposal={mockProposal} />);
    
    cy.get('[data-testid="yes-votes"]').should('contain', '10');
    cy.get('[data-testid="no-votes"]').should('contain', '5');
    cy.get('[data-testid="abstain-votes"]').should('contain', '2');
  });

  it('should handle vote button click', () => {
    const onVote = cy.stub();
    cy.mount(<ProposalCard proposal={mockProposal} onVote={onVote} />);
    
    cy.get('[data-testid="vote-yes-btn"]').click();
    cy.then(() => {
      expect(onVote).to.have.been.calledWith('yes');
    });
  });
});
```

## Performance Testing

### K6 Performance Tests
```javascript
// tests/performance/load-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';
import { Rate } from 'k6/metrics';

const errorRate = new Rate('errors');

export const options = {
  stages: [
    { duration: '2m', target: 100 }, // Ramp up
    { duration: '5m', target: 100 }, // Stay at 100 users
    { duration: '2m', target: 200 }, // Ramp up to 200 users
    { duration: '5m', target: 200 }, // Stay at 200 users
    { duration: '2m', target: 0 },   // Ramp down
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests must complete below 500ms
    http_req_failed: ['rate<0.1'],    // Error rate must be below 10%
    errors: ['rate<0.1'],
  },
};

const BASE_URL = 'http://localhost:3000';

export function setup() {
  // Login and get auth token
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

  // Test proposals endpoint
  const proposalsResponse = http.get(`${BASE_URL}/api/proposals`, params);
  check(proposalsResponse, {
    'proposals status is 200': (r) => r.status === 200,
    'proposals response time < 500ms': (r) => r.timings.duration < 500,
  });
  errorRate.add(proposalsResponse.status !== 200);

  sleep(1);

  // Test create proposal
  const proposalData = {
    title: `Load Test Proposal ${__VU}`,
    description: 'This is a load test proposal',
    type: 'governance'
  };
  
  const createResponse = http.post(`${BASE_URL}/api/proposals`, JSON.stringify(proposalData), params);
  check(createResponse, {
    'create proposal status is 201': (r) => r.status === 201,
    'create proposal response time < 1000ms': (r) => r.timings.duration < 1000,
  });
  errorRate.add(createResponse.status !== 201);

  sleep(1);
}
```

### Artillery Performance Tests
```yaml
# tests/performance/artillery-config.yml
config:
  target: 'http://localhost:3000'
  phases:
    - duration: 60
      arrivalRate: 5
    - duration: 120
      arrivalRate: 10
    - duration: 60
      arrivalRate: 5
  defaults:
    headers:
      Content-Type: 'application/json'
  plugins:
    metrics-by-endpoint:
      useOnlyRequestNames: true

scenarios:
  - name: "API Load Test"
    weight: 100
    flow:
      - post:
          url: "/api/auth/login"
          json:
            email: "test@example.com"
            password: "password123"
          capture:
            - json: "$.token"
              as: "authToken"
      
      - get:
          url: "/api/proposals"
          headers:
            Authorization: "Bearer {{ authToken }}"
      
      - post:
          url: "/api/proposals"
          headers:
            Authorization: "Bearer {{ authToken }}"
          json:
            title: "Load Test Proposal {{ $randomString() }}"
            description: "Load test proposal description"
            type: "governance"
```

## Test Automation

### GitHub Actions Workflow
```yaml
# .github/workflows/test.yml
name: Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  unit-tests:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run unit tests
      run: npm run test:unit
    
    - name: Upload coverage
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info

  integration-tests:
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: rechain_dao_test
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
        ports:
          - 3306:3306
      
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd="redis-cli ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
        ports:
          - 6379:6379
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Run database migrations
      run: npm run db:migrate
      env:
        DB_HOST: localhost
        DB_PORT: 3306
        DB_NAME: rechain_dao_test
        DB_USER: root
        DB_PASSWORD: root
    
    - name: Run integration tests
      run: npm run test:integration
      env:
        DB_HOST: localhost
        DB_PORT: 3306
        DB_NAME: rechain_dao_test
        DB_USER: root
        DB_PASSWORD: root
        REDIS_HOST: localhost
        REDIS_PORT: 6379

  e2e-tests:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Build application
      run: npm run build
    
    - name: Start application
      run: |
        npm start &
        sleep 30
    
    - name: Run E2E tests
      run: npm run test:e2e
      env:
        CYPRESS_baseUrl: http://localhost:3000

  performance-tests:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '18'
        cache: 'npm'
    
    - name: Install dependencies
      run: npm ci
    
    - name: Build application
      run: npm run build
    
    - name: Start application
      run: |
        npm start &
        sleep 30
    
    - name: Run performance tests
      run: npm run test:performance
```

## Test Data Management

### Test Data Factory
```typescript
// tests/factories/UserFactory.ts
import { faker } from '@faker-js/faker';
import { User } from '../../src/models/User';

export class UserFactory {
  static create(overrides: Partial<any> = {}) {
    return {
      email: faker.internet.email(),
      password: 'password123',
      firstName: faker.person.firstName(),
      lastName: faker.person.lastName(),
      isVerified: true,
      isActive: true,
      ...overrides
    };
  }

  static async createInDatabase(overrides: Partial<any> = {}) {
    const userData = this.create(overrides);
    return await User.create(userData);
  }

  static createMany(count: number, overrides: Partial<any> = {}) {
    return Array.from({ length: count }, () => this.create(overrides));
  }

  static async createManyInDatabase(count: number, overrides: Partial<any> = {}) {
    const users = this.createMany(count, overrides);
    return await User.insertMany(users);
  }
}
```

### Test Database Seeder
```typescript
// tests/seeders/DatabaseSeeder.ts
import { User } from '../../src/models/User';
import { Proposal } from '../../src/models/Proposal';
import { Vote } from '../../src/models/Vote';
import { UserFactory } from '../factories/UserFactory';
import { ProposalFactory } from '../factories/ProposalFactory';
import { VoteFactory } from '../factories/VoteFactory';

export class DatabaseSeeder {
  static async seed() {
    // Create test users
    const users = await UserFactory.createManyInDatabase(10);
    
    // Create test proposals
    const proposals = [];
    for (let i = 0; i < 5; i++) {
      const proposer = users[Math.floor(Math.random() * users.length)];
      const proposal = await ProposalFactory.createInDatabase({
        proposer: proposer._id
      });
      proposals.push(proposal);
    }
    
    // Create test votes
    for (const proposal of proposals) {
      const voters = users.filter(user => user._id.toString() !== proposal.proposer.toString());
      const voteCount = Math.floor(Math.random() * voters.length);
      
      for (let i = 0; i < voteCount; i++) {
        await VoteFactory.createInDatabase({
          proposal: proposal._id,
          voter: voters[i]._id,
          voteType: ['yes', 'no', 'abstain'][Math.floor(Math.random() * 3)]
        });
      }
    }
  }

  static async clear() {
    await Vote.deleteMany({});
    await Proposal.deleteMany({});
    await User.deleteMany({});
  }
}
```

## Conclusion

These testing frameworks provide comprehensive test coverage for the REChain DAO platform, including unit tests, integration tests, end-to-end tests, and performance tests. They ensure code quality, reliability, and performance of the application.

Remember: Regularly update test configurations and add new tests as the application evolves. Maintain test data and keep tests fast and reliable for efficient development workflows.
