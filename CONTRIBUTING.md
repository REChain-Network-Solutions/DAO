# Contributing to REChain DAO

Thank you for your interest in contributing to REChain DAO! This document provides guidelines and information for contributors.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Process](#development-process)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Issue Reporting](#issue-reporting)
- [Security](#security)
- [Community](#community)

## Code of Conduct

This project follows our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

### Prerequisites

- PHP 8.1+
- MySQL 8.0+
- Redis 6.0+
- Composer
- Git
- Node.js 18+ (for frontend assets)
- Docker (optional)
- Web3 wallet (for blockchain features)

### Setting Up Development Environment

1. **Fork the repository**
   - Click the "Fork" button on GitHub
   - Clone your fork locally

2. **Clone your fork**
   ```bash
   git clone https://github.com/your-username/REChain-DAO.git
   cd REChain-DAO
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/REChain-Network-Solutions/REChain-DAO.git
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
   php artisan key:generate
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

10. **Set up blockchain (optional)**
    ```bash
    # Install Hardhat for smart contract development
    npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
    npx hardhat compile
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
- `security/description` - Security fixes

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
- `security`: Security-related changes

**Examples:**
```
feat(auth): add OAuth2 integration
fix(api): resolve CORS issues
docs(readme): update installation instructions
security(wallet): implement input validation
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
   - Consider security implications

4. **Test your changes**
   ```bash
   # Run PHP tests
   composer test
   
   # Run linting
   composer lint
   
   # Run security checks
   composer audit
   
   # Build frontend assets
   npm run build
   
   # Run E2E tests
   npm run test:e2e
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
   - Document breaking changes

3. **Request review**
   - Assign appropriate reviewers
   - Add relevant labels
   - Request specific team members if needed

### PR Review Process

1. **Automated checks must pass**
   - All tests must pass
   - Code coverage must not decrease
   - Linting must pass
   - Security scans must pass
   - Quality gates must pass

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
- Implement proper error handling

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
    // Validate input
    $this->validateProposalData($proposalData);
    
    // Create proposal
    $proposal = new Proposal($proposalData);
    $proposal->user_id = $userId;
    $proposal->save();
    
    return $proposal;
}
```

### JavaScript/TypeScript Standards

- Use TypeScript for type safety
- Follow ESLint configuration
- Use modern ES6+ features
- Write functional components where applicable
- Add proper error boundaries

```typescript
interface ProposalData {
  title: string;
  description: string;
  type: ProposalType;
  amount?: number;
}

const createProposal = async (data: ProposalData): Promise<Proposal> => {
  try {
    const response = await api.post('/proposals', data);
    return response.data;
  } catch (error) {
    throw new Error(`Failed to create proposal: ${error.message}`);
  }
};
```

### Database Standards

- Use migrations for schema changes
- Follow naming conventions
- Add indexes for performance
- Use transactions for complex operations
- Implement proper foreign key constraints

### API Design

- Follow RESTful conventions
- Use appropriate HTTP status codes
- Implement proper error handling
- Add input validation
- Document endpoints with OpenAPI
- Implement rate limiting

### Smart Contract Standards

- Follow Solidity style guide
- Use OpenZeppelin contracts where possible
- Implement proper access controls
- Add comprehensive tests
- Document gas costs

## Testing

### Test Types

1. **Unit Tests**
   - Test individual functions and classes
   - Use PHPUnit for PHP
   - Use Jest for JavaScript
   - Aim for 80%+ coverage

2. **Integration Tests**
   - Test API endpoints
   - Test database interactions
   - Test external service integrations
   - Test smart contract interactions

3. **End-to-End Tests**
   - Test complete user workflows
   - Use Cypress or Playwright
   - Test critical user paths
   - Test blockchain interactions

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
    $this->assertEquals(123, $proposal->user_id);
}

// Integration test example
public function testCreateProposalViaAPI(): void
{
    $response = $this->postJson('/api/proposals', [
        'title' => 'Test Proposal',
        'description' => 'Test Description',
        'type' => 'governance'
    ]);
    
    $response->assertStatus(201)
            ->assertJsonStructure([
                'id',
                'title',
                'description',
                'type',
                'created_at'
            ]);
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

# Run security audit
composer audit

# Run E2E tests
npm run test:e2e
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

### Smart Contract Documentation

- Document function purposes
- Explain gas costs
- Provide usage examples
- Document security considerations

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
7. **Browser/Node version** for frontend issues

### Feature Requests

When requesting features, include:

1. **Clear description** of the feature
2. **Use case** and motivation
3. **Proposed solution** or approach
4. **Alternatives** considered
5. **Additional context** or examples

### Security Issues

**IMPORTANT: DO NOT REPORT SECURITY VULNERABILITIES PUBLICLY**

For security vulnerabilities, email: security@rechain-dao.com

### Issue Labels

- `bug` - Something isn't working
- `enhancement` - New feature or request
- `documentation` - Improvements to documentation
- `security` - Security-related issues
- `performance` - Performance issues
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention is needed
- `priority: critical` - Critical priority
- `priority: high` - High priority
- `priority: medium` - Medium priority
- `priority: low` - Low priority

## Security

### Security Guidelines

- Never commit secrets or API keys
- Use environment variables for sensitive data
- Implement proper input validation
- Follow OWASP security guidelines
- Regular security audits

### Security Testing

- Run security scans on all PRs
- Test for common vulnerabilities
- Review dependencies for known issues
- Implement proper authentication and authorization

### Reporting Security Issues

For security vulnerabilities:
- Email: security@rechain-dao.com
- PGP key available on request
- Response time: 48 hours

## Community

### Communication Channels

- **GitHub Discussions** - General questions and discussions
- **GitHub Issues** - Bug reports and feature requests
- **Discord** - Real-time community chat
- **Email** - info@rechain-dao.com

### Contribution Recognition

Contributors will be recognized in:

- CONTRIBUTORS.md file
- Release notes
- Project documentation
- Community acknowledgments
- Contributor badges

### Ways to Contribute

- Code contributions
- Documentation improvements
- Bug reports and testing
- Feature suggestions
- Community support
- Security research
- Translation efforts

## Getting Help

### Resources

- [Documentation](docs/)
- [API Reference](docs/api.md)
- [Security Policy](.github/SECURITY.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)

### Support

- **New contributors**: Look for `good first issue` labels
- **Questions**: Use GitHub Discussions
- **Bugs**: Create an issue with detailed information
- **Security**: Email security@rechain-dao.com

## Recognition

Contributors will be recognized in:

- CONTRIBUTORS.md file
- Release notes
- Project documentation
- Community acknowledgments
- Annual contributor awards

## Thank You

Thank you for contributing to REChain DAO! Your contributions help make decentralized governance more accessible and effective for communities worldwide.

---

**Happy Contributing! 🚀**
