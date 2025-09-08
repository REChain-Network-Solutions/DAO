# Contributing to DAO Platform

Thank you for your interest in contributing to the DAO Platform! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Issue Reporting](#issue-reporting)

## Code of Conduct

This project follows our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

### Prerequisites

- PHP 8.1+
- MySQL 8.0+
- Redis 6.0+
- Composer
- Git
- Node.js (for frontend assets)
- Docker (optional)

### Setting Up Development Environment

1. **Fork the repository**
   - Click the "Fork" button on GitHub
   - Clone your fork locally

2. **Clone your fork**
   ```bash
   git clone https://github.com/your-username/dao-platform.git
   cd dao-platform
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/original-username/dao-platform.git
   ```

4. **Install PHP dependencies**
   ```bash
   composer install
   ```

5. **Install frontend dependencies**
   ```bash
   npm install
   ```

6. **Set up environment**
   ```bash
   cp .env.example .env
   # Edit .env with your database and configuration settings
   ```

7. **Set up database**
   ```bash
   # Run migrations and seed the database
   php artisan migrate --seed
   ```

8. **Build frontend assets**
   ```bash
   npm run build
   ```

9. **Start development server**
   ```bash
   php artisan serve
   ```

## Development Process

### Branch Naming Convention

Use descriptive branch names:
- `feature/description` - New features
- `bugfix/description` - Bug fixes
- `hotfix/description` - Critical fixes
- `docs/description` - Documentation updates
- `refactor/description` - Code refactoring
- `test/description` - Test improvements

### Commit Message Convention

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(auth): add OAuth2 integration
fix(api): resolve CORS issues
docs(readme): update installation instructions
```

## Pull Request Process

### Before Submitting

1. **Check existing issues and PRs**
   - Search for similar issues or PRs
   - Comment on existing issues if you're working on them

2. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
   - Write clean, readable code
   - Follow coding standards
   - Add tests for new functionality
   - Update documentation

4. **Test your changes**
   ```bash
   # Run PHP tests
   composer test
   
   # Run linting
   composer lint
   
   # Build frontend assets
   npm run build
   ```

5. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new feature"
   ```

6. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

### Submitting a Pull Request

1. **Create a Pull Request**
   - Go to your fork on GitHub
   - Click "New Pull Request"
   - Select the appropriate branches

2. **Fill out the PR template**
   - Provide a clear description
   - Link related issues
   - Add screenshots if applicable

3. **Request review**
   - Assign appropriate reviewers
   - Add relevant labels
   - Request specific team members if needed

### PR Review Process

1. **Automated checks must pass**
   - All tests must pass
   - Code coverage must not decrease
   - Linting must pass

2. **Code review**
   - At least one approval required
   - Address all review comments
   - Update PR based on feedback

3. **Merge**
   - Squash and merge for feature branches
   - Merge commit for release branches
   - Delete feature branch after merge

## Coding Standards

### PHP Coding Standards

- Follow PSR-12 coding style
- Use type declarations where possible
- Write meaningful variable and function names
- Add docblocks for classes and methods
- Use modern PHP features (PHP 8.1+)

```php
/**
 * Creates a new proposal in the DAO
 *
 * @param array $proposalData The proposal data
 * @param int $userId The ID of the user creating the proposal
 * @return Proposal The created proposal
 * @throws ValidationException
 */
public function createProposal(array $proposalData, int $userId): Proposal
{
    // Implementation
}
```

### Database Standards

- Use migrations for schema changes
- Follow naming conventions
- Add indexes for performance
- Use transactions for complex operations

### API Design

- Follow RESTful conventions
- Use appropriate HTTP status codes
- Implement proper error handling
- Add input validation
- Document endpoints with OpenAPI

## Testing

### Test Types

1. **Unit Tests**
   - Test individual functions and classes
   - Use PHPUnit
   - Aim for high coverage

2. **Integration Tests**
   - Test API endpoints
   - Test database interactions
   - Test external service integrations

3. **End-to-End Tests**
   - Test complete user workflows
   - Use browser testing tools
   - Test critical user paths

### Writing Tests

```php
// Unit test example
public function testCreateProposalWithValidData(): void
{
    $proposalData = [
        'title' => 'Test Proposal',
        'description' => 'Test Description',
        'type' => 'governance'
    ];
    
    $proposal = $this->proposalService->create($proposalData, 123);
    
    $this->assertNotNull($proposal);
    $this->assertEquals('Test Proposal', $proposal->title);
}
```

### Running Tests

```bash
# Run all tests
composer test

# Run tests with coverage
composer test:coverage

# Run specific test file
vendor/bin/phpunit tests/ProposalServiceTest.php

# Run linting
composer lint
```

## Documentation

### Code Documentation

- Add docblocks for functions and classes
- Document complex algorithms
- Explain business logic
- Keep comments up to date

### API Documentation

- Use OpenAPI/Swagger for API docs
- Provide examples for all endpoints
- Document request/response schemas
- Include error responses

### User Documentation

- Update user guides for new features
- Add screenshots for UI changes
- Keep installation instructions current
- Document configuration options

## Issue Reporting

### Bug Reports

When reporting bugs, include:

1. **Clear description** of the issue
2. **Steps to reproduce** the problem
3. **Expected behavior** vs actual behavior
4. **Environment details** (OS, PHP version, database version)
5. **Screenshots** if applicable
6. **Error logs** if available

### Feature Requests

When requesting features, include:

1. **Clear description** of the feature
2. **Use case** and motivation
3. **Proposed solution** or approach
4. **Alternatives** considered
5. **Additional context** or examples

### Issue Labels

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements to documentation
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention is needed
- `priority: high` - High priority
- `priority: medium` - Medium priority
- `priority: low` - Low priority

## Getting Help

- **GitHub Discussions** - General questions and discussions
- **GitHub Issues** - Bug reports and feature requests
- **Email** - support@dao-platform.com

## Recognition

Contributors will be recognized in:

- CONTRIBUTORS.md file
- Release notes
- Project documentation
- Community acknowledgments

## Thank You

Thank you for contributing to the DAO Platform! Your contributions help make decentralized governance more accessible and effective for communities worldwide.

---

**Happy Contributing! 🚀**
