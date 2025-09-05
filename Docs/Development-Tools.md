# Development Tools

## Overview

This document provides comprehensive development tools and configurations for the REChain DAO platform, including IDE setup, debugging tools, testing frameworks, and development workflows.

## Table of Contents

1. [IDE Configuration](#ide-configuration)
2. [Debugging Tools](#debugging-tools)
3. [Testing Frameworks](#testing-frameworks)
4. [Code Quality Tools](#code-quality-tools)
5. [Development Workflow](#development-workflow)
6. [Local Development Setup](#local-development-setup)

## IDE Configuration

### VS Code Configuration
```json
{
  "settings": {
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true,
      "source.organizeImports": true
    },
    "editor.tabSize": 2,
    "editor.insertSpaces": true,
    "files.trimTrailingWhitespace": true,
    "files.insertFinalNewline": true,
    "files.trimFinalNewlines": true,
    "typescript.preferences.importModuleSpecifier": "relative",
    "javascript.preferences.importModuleSpecifier": "relative",
    "php.suggest.basic": false,
    "php.validate.enable": true,
    "php.validate.executablePath": "/usr/bin/php",
    "go.useLanguageServer": true,
    "go.formatTool": "goimports",
    "go.lintTool": "golangci-lint"
  },
  "extensions": [
    "ms-vscode.vscode-typescript-next",
    "bradlc.vscode-tailwindcss",
    "esbenp.prettier-vscode",
    "ms-vscode.vscode-eslint",
    "ms-vscode.vscode-json",
    "redhat.vscode-yaml",
    "ms-kubernetes-tools.vscode-kubernetes-tools",
    "ms-vscode-remote.remote-containers",
    "ms-vscode-remote.remote-ssh",
    "golang.go",
    "ms-python.python",
    "ms-php.php",
    "formulahendry.auto-rename-tag",
    "christian-kohler.path-intellisense",
    "ms-vscode.vscode-docker"
  ]
}
```

### VS Code Workspace
```json
{
  "folders": [
    {
      "name": "REChain DAO",
      "path": "."
    },
    {
      "name": "Frontend",
      "path": "./frontend"
    },
    {
      "name": "Backend",
      "path": "./backend"
    },
    {
      "name": "Mobile",
      "path": "./mobile"
    },
    {
      "name": "Infrastructure",
      "path": "./infrastructure"
    }
  ],
  "settings": {
    "files.exclude": {
      "**/node_modules": true,
      "**/vendor": true,
      "**/.git": true,
      "**/dist": true,
      "**/build": true
    },
    "search.exclude": {
      "**/node_modules": true,
      "**/vendor": true,
      "**/dist": true,
      "**/build": true
    }
  },
  "tasks": {
    "version": "2.0.0",
    "tasks": [
      {
        "label": "Install Dependencies",
        "type": "shell",
        "command": "npm install",
        "group": "build",
        "presentation": {
          "echo": true,
          "reveal": "always",
          "focus": false,
          "panel": "shared"
        }
      },
      {
        "label": "Run Tests",
        "type": "shell",
        "command": "npm test",
        "group": "test",
        "presentation": {
          "echo": true,
          "reveal": "always",
          "focus": false,
          "panel": "shared"
        }
      },
      {
        "label": "Start Development Server",
        "type": "shell",
        "command": "npm run dev",
        "group": "build",
        "isBackground": true,
        "presentation": {
          "echo": true,
          "reveal": "always",
          "focus": false,
          "panel": "shared"
        }
      }
    ]
  }
}
```

### IntelliJ IDEA Configuration
```xml
<!-- .idea/codeStyles/Project.xml -->
<component name="ProjectCodeStyleConfiguration">
  <code_scheme name="Project" version="173">
    <option name="OTHER_INDENT_OPTIONS">
      <value>
        <option name="INDENT_SIZE" value="2" />
        <option name="TAB_SIZE" value="2" />
        <option name="USE_TAB_CHARACTER" value="false" />
        <option name="SMART_TABS" value="false" />
        <option name="LABEL_INDENT_SIZE" value="0" />
        <option name="LABEL_INDENT_ABSOLUTE" value="false" />
        <option name="CONTINUATION_INDENT_SIZE" value="2" />
      </value>
    </option>
  </code_scheme>
</component>
```

## Debugging Tools

### Chrome DevTools Configuration
```javascript
// debug-config.js
const debugConfig = {
  // Enable source maps
  sourceMaps: true,
  
  // Debug configuration
  debug: {
    enabled: true,
    level: 'debug',
    logLevel: 'verbose'
  },
  
  // Performance monitoring
  performance: {
    enabled: true,
    sampling: 0.1,
    maxSamples: 1000
  },
  
  // Memory profiling
  memory: {
    enabled: true,
    heapSnapshot: true,
    allocationTimeline: true
  },
  
  // Network monitoring
  network: {
    enabled: true,
    logRequests: true,
    logResponses: false
  }
};

// Debug helper functions
const debugHelpers = {
  log: (message, data) => {
    if (debugConfig.debug.enabled) {
      console.log(`[DEBUG] ${message}`, data);
    }
  },
  
  error: (message, error) => {
    console.error(`[ERROR] ${message}`, error);
  },
  
  warn: (message, data) => {
    console.warn(`[WARN] ${message}`, data);
  },
  
  time: (label) => {
    if (debugConfig.debug.enabled) {
      console.time(label);
    }
  },
  
  timeEnd: (label) => {
    if (debugConfig.debug.enabled) {
      console.timeEnd(label);
    }
  }
};

// Export for use
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { debugConfig, debugHelpers };
}
```

### Node.js Debugging
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch Program",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/src/index.js",
      "console": "integratedTerminal",
      "env": {
        "NODE_ENV": "development",
        "DEBUG": "rechain-dao:*"
      },
      "sourceMaps": true,
      "outFiles": ["${workspaceFolder}/dist/**/*.js"]
    },
    {
      "name": "Attach to Process",
      "type": "node",
      "request": "attach",
      "port": 9229,
      "restart": true,
      "localRoot": "${workspaceFolder}",
      "remoteRoot": "/app"
    },
    {
      "name": "Debug Tests",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/node_modules/.bin/jest",
      "args": ["--runInBand", "--no-cache"],
      "console": "integratedTerminal",
      "internalConsoleOptions": "neverOpen",
      "env": {
        "NODE_ENV": "test"
      }
    }
  ]
}
```

### PHP Debugging
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Listen for Xdebug",
      "type": "php",
      "request": "launch",
      "port": 9003,
      "pathMappings": {
        "/var/www/html": "${workspaceFolder}"
      },
      "ignore": [
        "**/vendor/**/*.php"
      ]
    },
    {
      "name": "Launch currently open script",
      "type": "php",
      "request": "launch",
      "program": "${file}",
      "cwd": "${fileDirname}",
      "port": 0,
      "runtimeArgs": [
        "-dxdebug.start_with_request=yes"
      ],
      "env": {
        "XDEBUG_MODE": "debug,develop",
        "XDEBUG_CONFIG": "client_port=${port}"
      }
    }
  ]
}
```

## Testing Frameworks

### Jest Configuration
```javascript
// jest.config.js
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
    '!src/**/*.spec.ts'
  ],
  coverageDirectory: 'coverage',
  coverageReporters: ['text', 'lcov', 'html'],
  setupFilesAfterEnv: ['<rootDir>/tests/setup.ts'],
  testTimeout: 10000,
  verbose: true,
  globals: {
    'ts-jest': {
      tsconfig: 'tsconfig.json'
    }
  }
};
```

### PHPUnit Configuration
```xml
<!-- phpunit.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<phpunit xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:noNamespaceSchemaLocation="https://schema.phpunit.de/9.5/phpunit.xsd"
         bootstrap="tests/bootstrap.php"
         colors="true"
         processIsolation="false"
         stopOnFailure="false">
    <testsuites>
        <testsuite name="Unit">
            <directory>tests/Unit</directory>
        </testsuite>
        <testsuite name="Integration">
            <directory>tests/Integration</directory>
        </testsuite>
        <testsuite name="Feature">
            <directory>tests/Feature</directory>
        </testsuite>
    </testsuites>
    <coverage>
        <include>
            <directory suffix=".php">src</directory>
        </include>
        <exclude>
            <directory>tests</directory>
            <directory>vendor</directory>
        </exclude>
        <report>
            <html outputDirectory="coverage/html"/>
            <text outputFile="coverage/text.txt"/>
            <clover outputFile="coverage/clover.xml"/>
        </report>
    </coverage>
    <php>
        <env name="APP_ENV" value="testing"/>
        <env name="DB_CONNECTION" value="sqlite"/>
        <env name="DB_DATABASE" value=":memory:"/>
    </php>
</phpunit>
```

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

## Code Quality Tools

### ESLint Configuration
```javascript
// .eslintrc.js
module.exports = {
  env: {
    browser: true,
    es2021: true,
    node: true,
    jest: true
  },
  extends: [
    'eslint:recommended',
    '@typescript-eslint/recommended',
    'plugin:react/recommended',
    'plugin:react-hooks/recommended',
    'plugin:jsx-a11y/recommended',
    'plugin:import/recommended',
    'plugin:import/typescript',
    'prettier'
  ],
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaFeatures: {
      jsx: true
    },
    ecmaVersion: 12,
    sourceType: 'module'
  },
  plugins: [
    'react',
    '@typescript-eslint',
    'jsx-a11y',
    'import',
    'prettier'
  ],
  rules: {
    'prettier/prettier': 'error',
    'react/react-in-jsx-scope': 'off',
    'react/prop-types': 'off',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'warn',
    'import/order': [
      'error',
      {
        groups: [
          'builtin',
          'external',
          'internal',
          'parent',
          'sibling',
          'index'
        ],
        'newlines-between': 'always'
      }
    ]
  },
  settings: {
    react: {
      version: 'detect'
    },
    'import/resolver': {
      typescript: {
        alwaysTryTypes: true
      }
    }
  }
};
```

### Prettier Configuration
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2,
  "useTabs": false,
  "bracketSpacing": true,
  "bracketSameLine": false,
  "arrowParens": "avoid",
  "endOfLine": "lf",
  "quoteProps": "as-needed",
  "jsxSingleQuote": true,
  "proseWrap": "preserve"
}
```

### PHP CS Fixer Configuration
```php
<?php
// .php-cs-fixer.php
$finder = PhpCsFixer\Finder::create()
    ->in(__DIR__)
    ->exclude('vendor')
    ->exclude('node_modules')
    ->exclude('storage')
    ->exclude('bootstrap/cache')
    ->name('*.php')
    ->notName('*.blade.php')
    ->ignoreDotFiles(true)
    ->ignoreVCS(true);

return PhpCsFixer\Config::create()
    ->setRules([
        '@PSR12' => true,
        'array_syntax' => ['syntax' => 'short'],
        'ordered_imports' => ['sort_algorithm' => 'alpha'],
        'no_unused_imports' => true,
        'not_operator_with_successor_space' => true,
        'trailing_comma_in_multiline' => true,
        'phpdoc_scalar' => true,
        'unary_operator_spaces' => true,
        'binary_operator_spaces' => true,
        'blank_line_before_statement' => [
            'statements' => ['break', 'continue', 'declare', 'return', 'throw', 'try'],
        ],
        'phpdoc_single_line_var_spacing' => true,
        'phpdoc_var_without_name' => true,
        'method_argument_space' => [
            'on_multiline' => 'ensure_fully_multiline',
            'keep_multiple_spaces_after_comma' => true,
        ],
    ])
    ->setFinder($finder);
```

## Development Workflow

### Git Hooks
```bash
#!/bin/bash
# .git/hooks/pre-commit

# Run linting
echo "Running ESLint..."
npm run lint
if [ $? -ne 0 ]; then
    echo "ESLint failed. Please fix the errors and try again."
    exit 1
fi

# Run type checking
echo "Running TypeScript type checking..."
npm run type-check
if [ $? -ne 0 ]; then
    echo "TypeScript type checking failed. Please fix the errors and try again."
    exit 1
fi

# Run tests
echo "Running tests..."
npm run test:unit
if [ $? -ne 0 ]; then
    echo "Tests failed. Please fix the failing tests and try again."
    exit 1
fi

# Run formatting
echo "Running Prettier..."
npm run format:check
if [ $? -ne 0 ]; then
    echo "Code formatting issues found. Running Prettier..."
    npm run format
    echo "Please stage the formatted files and commit again."
    exit 1
fi

echo "Pre-commit checks passed!"
```

### Husky Configuration
```json
{
  "husky": {
    "hooks": {
      "pre-commit": "lint-staged",
      "commit-msg": "commitlint -E HUSKY_GIT_PARAMS",
      "pre-push": "npm run test:ci"
    }
  },
  "lint-staged": {
    "*.{js,jsx,ts,tsx}": [
      "eslint --fix",
      "prettier --write"
    ],
    "*.{json,md,yml,yaml}": [
      "prettier --write"
    ],
    "*.php": [
      "php-cs-fixer fix --config=.php-cs-fixer.php"
    ]
  }
}
```

### Commitlint Configuration
```javascript
// commitlint.config.js
module.exports = {
  extends: ['@commitlint/config-conventional'],
  rules: {
    'type-enum': [
      2,
      'always',
      [
        'feat',
        'fix',
        'docs',
        'style',
        'refactor',
        'perf',
        'test',
        'chore',
        'ci',
        'build',
        'revert'
      ]
    ],
    'subject-case': [2, 'never', ['sentence-case', 'start-case', 'pascal-case', 'upper-case']],
    'subject-empty': [2, 'never'],
    'subject-full-stop': [2, 'never', '.'],
    'type-case': [2, 'always', 'lower-case'],
    'type-empty': [2, 'never']
  }
};
```

## Local Development Setup

### Docker Compose for Development
```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "3000:3000"
      - "9229:9229"  # Debug port
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - DEBUG=rechain-dao:*
    command: npm run dev
    depends_on:
      - mysql
      - redis

  mysql:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=rechain_dao
      - MYSQL_USER=dev
      - MYSQL_PASSWORD=dev
    volumes:
      - mysql_data:/var/lib/mysql
      - ./docker/mysql/init.sql:/docker-entrypoint-initdb.d/init.sql

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./docker/nginx/ssl:/etc/nginx/ssl
    depends_on:
      - app

volumes:
  mysql_data:
  redis_data:
```

### Development Scripts
```json
{
  "scripts": {
    "dev": "nodemon src/index.js",
    "dev:debug": "nodemon --inspect src/index.js",
    "dev:watch": "nodemon --watch src --ext js,ts src/index.js",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:ci": "jest --ci --coverage --watchAll=false",
    "lint": "eslint src/**/*.{js,ts}",
    "lint:fix": "eslint src/**/*.{js,ts} --fix",
    "format": "prettier --write src/**/*.{js,ts,json,md}",
    "format:check": "prettier --check src/**/*.{js,ts,json,md}",
    "type-check": "tsc --noEmit",
    "build": "tsc && npm run build:copy",
    "build:copy": "cp -r src/public dist/",
    "start": "node dist/index.js",
    "docker:dev": "docker-compose -f docker-compose.dev.yml up",
    "docker:build": "docker-compose -f docker-compose.dev.yml build",
    "docker:down": "docker-compose -f docker-compose.dev.yml down",
    "db:migrate": "knex migrate:latest",
    "db:seed": "knex seed:run",
    "db:reset": "knex migrate:rollback && knex migrate:latest && knex seed:run"
  }
}
```

### Environment Configuration
```bash
# .env.development
NODE_ENV=development
PORT=3000
DEBUG=rechain-dao:*

# Database
DB_HOST=localhost
DB_PORT=3306
DB_NAME=rechain_dao
DB_USER=dev
DB_PASSWORD=dev

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=

# JWT
JWT_SECRET=dev-secret-key
JWT_EXPIRES_IN=1h

# API
API_BASE_URL=http://localhost:3000/api
API_VERSION=v1

# External Services
BLOCKCHAIN_RPC_URL=http://localhost:8545
BLOCKCHAIN_CHAIN_ID=1337

# Logging
LOG_LEVEL=debug
LOG_FORMAT=pretty
```

## Conclusion

These development tools provide a comprehensive development environment for the REChain DAO platform, including IDE configuration, debugging tools, testing frameworks, and code quality tools. They ensure consistent code quality and efficient development workflows.

Remember: Regularly update development tools and configurations to maintain compatibility and leverage new features. Customize tools based on team preferences and project requirements.
