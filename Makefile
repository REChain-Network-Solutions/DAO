.PHONY: help install dev build start test lint format clean docker-build docker-run docker-dev

# Default target
help:
	@echo "Available commands:"
	@echo "  install      - Install dependencies"
	@echo "  dev          - Start development server"
	@echo "  build        - Build for production"
	@echo "  start        - Start production server"
	@echo "  test         - Run tests"
	@echo "  test-watch   - Run tests in watch mode"
	@echo "  lint         - Run linter"
	@echo "  format       - Format code"
	@echo "  clean        - Clean build artifacts"
	@echo "  docker-build - Build Docker image"
	@echo "  docker-run   - Run Docker container"
	@echo "  docker-dev   - Start development with Docker"
	@echo "  db-migrate   - Run database migrations"
	@echo "  db-seed      - Seed database"
	@echo "  db-reset     - Reset database"

# Install dependencies
install:
	npm install

# Development
dev:
	npm run dev

# Build
build:
	npm run build

# Start production server
start:
	npm start

# Testing
test:
	npm test

test-watch:
	npm run test:watch

test-coverage:
	npm run test:coverage

# Code quality
lint:
	npm run lint

lint-fix:
	npm run lint:fix

format:
	npm run format

type-check:
	npm run type-check

# Database
db-migrate:
	npm run db:migrate

db-seed:
	npm run db:seed

db-reset:
	npm run db:reset

# Clean
clean:
	npm run clean

# Docker
docker-build:
	docker build -t rechain-dao .

docker-run:
	docker run -p 3000:3000 rechain-dao

docker-dev:
	docker-compose -f docker-compose.dev.yml up

docker-prod:
	docker-compose -f docker-compose.yml up

docker-stop:
	docker-compose down

# Security
security-audit:
	npm audit

security-scan:
	npm run security:scan

# Documentation
docs-generate:
	npm run docs:generate

docs-serve:
	npm run docs:serve

# Release
release:
	npm run release

release-major:
	npm run release:major

release-minor:
	npm run release:minor

release-patch:
	npm run release:patch
