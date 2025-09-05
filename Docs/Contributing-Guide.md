# REChain DAO - Contributing Guide

## Welcome Contributors! 🎉

Thank you for your interest in contributing to REChain DAO! This guide will help you understand how to contribute effectively to our project and become part of our growing community.

## Table of Contents

1. [Code of Conduct](#code-of-conduct)
2. [Getting Started](#getting-started)
3. [Types of Contributions](#types-of-contributions)
4. [Development Workflow](#development-workflow)
5. [Coding Standards](#coding-standards)
6. [Testing Guidelines](#testing-guidelines)
7. [Documentation](#documentation)
8. [Community Guidelines](#community-guidelines)
9. [Release Process](#release-process)
10. [Recognition](#recognition)

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of:
- Age, body size, disability, ethnicity
- Gender identity and expression
- Level of experience, education
- Nationality, personal appearance
- Race, religion, sexual orientation

### Expected Behavior

- **Be respectful** and inclusive in all interactions
- **Be constructive** in feedback and discussions
- **Be patient** with newcomers and learning processes
- **Be collaborative** and help others succeed
- **Be professional** in all communications

### Unacceptable Behavior

- Harassment, discrimination, or intimidation
- Trolling, insulting, or derogatory comments
- Personal attacks or political discussions
- Spam or off-topic discussions
- Any behavior that makes others feel unwelcome

### Enforcement

Violations of our Code of Conduct will be addressed through:
1. **Warning**: First-time minor violations
2. **Temporary ban**: Repeated or serious violations
3. **Permanent ban**: Severe or persistent violations

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- **Git** installed and configured
- **PHP 8.2+** with required extensions
- **MySQL 5.7+** or **MariaDB 10.3+**
- **Composer** for dependency management
- **Node.js 16+** and **npm** for frontend assets
- A **GitHub account**
- Basic knowledge of **PHP**, **JavaScript**, and **SQL**

### Initial Setup

1. **Fork the Repository**
   ```bash
   # Go to https://github.com/REChain-Network-Solutions/DAO
   # Click "Fork" button
   ```

2. **Clone Your Fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/DAO.git
   cd DAO
   ```

3. **Add Upstream Remote**
   ```bash
   git remote add upstream https://github.com/REChain-Network-Solutions/DAO.git
   ```

4. **Install Dependencies**
   ```bash
   composer install
   npm install
   ```

5. **Set Up Development Environment**
   ```bash
   cp includes/config-example.php includes/config.php
   # Edit config.php with your settings
   ```

6. **Initialize Database**
   ```bash
   mysql -u root -p < Extras/SQL/schema.sql
   ```

## Types of Contributions

### 🐛 Bug Reports

**Before reporting a bug:**
- Check if the issue already exists
- Search closed issues for similar problems
- Test with the latest version

**When reporting a bug, include:**
- Clear, descriptive title
- Steps to reproduce
- Expected vs actual behavior
- Screenshots/videos if applicable
- System information (OS, PHP version, etc.)
- Error logs if available

**Bug Report Template:**
```markdown
## Bug Description
Brief description of the bug

## Steps to Reproduce
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

## Expected Behavior
What you expected to happen

## Actual Behavior
What actually happened

## Screenshots
If applicable, add screenshots

## Environment
- OS: [e.g., Ubuntu 20.04]
- PHP Version: [e.g., 8.3.0]
- Browser: [e.g., Chrome 91]

## Additional Context
Any other context about the problem
```

### ✨ Feature Requests

**Before requesting a feature:**
- Check if the feature already exists
- Search existing feature requests
- Consider if it aligns with project goals

**When requesting a feature, include:**
- Clear, descriptive title
- Detailed description
- Use case and motivation
- Proposed solution (if any)
- Alternatives considered
- Additional context

**Feature Request Template:**
```markdown
## Feature Description
Brief description of the feature

## Problem Statement
What problem does this feature solve?

## Proposed Solution
Describe your proposed solution

## Use Cases
Who would use this feature and how?

## Alternatives Considered
What other solutions did you consider?

## Additional Context
Any other context or screenshots
```

### 💻 Code Contributions

**Types of code contributions:**
- Bug fixes
- New features
- Performance improvements
- Code refactoring
- Documentation updates
- Test improvements

**Before submitting code:**
- Ensure your code follows our standards
- Write or update tests
- Update documentation
- Test thoroughly

### 📚 Documentation

**Documentation contributions:**
- Fix typos and grammar
- Improve clarity and structure
- Add missing information
- Translate to other languages
- Create tutorials and guides

### 🧪 Testing

**Testing contributions:**
- Write unit tests
- Write integration tests
- Improve test coverage
- Fix failing tests
- Performance testing

### 🎨 Design

**Design contributions:**
- UI/UX improvements
- New themes and templates
- Icon and graphic design
- User experience research
- Accessibility improvements

## Development Workflow

### Branch Strategy

We use **Git Flow** for our branching strategy:

- **`main`**: Production-ready code
- **`develop`**: Integration branch for features
- **`feature/*`**: New features
- **`bugfix/*`**: Bug fixes
- **`hotfix/*`**: Critical production fixes
- **`release/*`**: Release preparation

### Creating a Branch

```bash
# Update your local main branch
git checkout main
git pull upstream main

# Create a new feature branch
git checkout -b feature/your-feature-name

# Or for bug fixes
git checkout -b bugfix/issue-number-description
```

### Making Changes

1. **Make your changes**
   - Write clean, readable code
   - Follow coding standards
   - Add comments where necessary

2. **Test your changes**
   ```bash
   # Run PHP tests
   composer test
   
   # Run JavaScript tests
   npm test
   
   # Run integration tests
   composer test:integration
   ```

3. **Update documentation**
   - Update relevant docs
   - Add code comments
   - Update changelog if needed

4. **Commit your changes**
   ```bash
   git add .
   git commit -m "feat: add new user authentication feature"
   ```

### Commit Message Format

We follow the **Conventional Commits** specification:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```bash
feat(auth): add two-factor authentication
fix(api): resolve user creation validation error
docs(readme): update installation instructions
test(user): add unit tests for user registration
```

### Submitting a Pull Request

1. **Push your branch**
   ```bash
   git push origin feature/your-feature-name
   ```

2. **Create Pull Request**
   - Go to your fork on GitHub
   - Click "New Pull Request"
   - Select your branch
   - Fill out the PR template

3. **PR Template**
   ```markdown
   ## Description
   Brief description of changes

   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Breaking change
   - [ ] Documentation update

   ## Testing
   - [ ] Unit tests pass
   - [ ] Integration tests pass
   - [ ] Manual testing completed

   ## Checklist
   - [ ] Code follows style guidelines
   - [ ] Self-review completed
   - [ ] Documentation updated
   - [ ] No breaking changes (or documented)

   ## Related Issues
   Closes #123
   ```

4. **Address Review Feedback**
   - Respond to comments
   - Make requested changes
   - Update tests if needed
   - Re-request review when ready

## Coding Standards

### PHP Standards

**Follow PSR-12:**
```php
<?php

declare(strict_types=1);

namespace Rechain\DAO\Module;

use Rechain\DAO\Traits\BaseTrait;

/**
 * Example class demonstrating coding standards
 */
class ExampleClass
{
    use BaseTrait;

    private string $property;
    private array $data = [];

    public function __construct(string $property)
    {
        $this->property = $property;
    }

    /**
     * Example method with proper documentation
     *
     * @param string $input Input string
     * @return string Processed output
     * @throws InvalidArgumentException
     */
    public function processInput(string $input): string
    {
        if (empty($input)) {
            throw new InvalidArgumentException('Input cannot be empty');
        }

        return strtoupper(trim($input));
    }
}
```

**Naming Conventions:**
- Classes: `PascalCase`
- Methods: `camelCase`
- Variables: `camelCase`
- Constants: `UPPER_SNAKE_CASE`
- Database tables: `snake_case`

### JavaScript Standards

**Follow ESLint configuration:**
```javascript
/**
 * Example JavaScript module
 */
(function($) {
    'use strict';

    const ExampleModule = {
        /**
         * Initialize the module
         */
        init: function() {
            this.bindEvents();
            this.setupComponents();
        },

        /**
         * Bind event handlers
         */
        bindEvents: function() {
            $(document).on('click', '.example-button', this.handleClick);
        },

        /**
         * Handle button click
         * @param {Event} event - Click event
         */
        handleClick: function(event) {
            event.preventDefault();
            console.log('Button clicked');
        }
    };

    // Initialize when DOM is ready
    $(document).ready(function() {
        ExampleModule.init();
    });

})(jQuery);
```

### Database Standards

**Table Naming:**
- Use `snake_case`
- Be descriptive and concise
- Use plural forms for tables

**Column Naming:**
- Use `snake_case`
- Include table prefix for foreign keys
- Be descriptive

**Example:**
```sql
CREATE TABLE user_profiles (
    profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    profile_bio TEXT,
    profile_website VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    INDEX idx_user_id (user_id)
);
```

## Testing Guidelines

### Unit Testing

**PHPUnit Tests:**
```php
<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;
use Rechain\DAO\User;

class UserTest extends TestCase
{
    private User $user;

    protected function setUp(): void
    {
        $this->user = new User();
    }

    public function testUserCreation(): void
    {
        $userData = [
            'user_name' => 'testuser',
            'user_email' => 'test@example.com',
            'user_password' => 'password123'
        ];

        $result = $this->user->create_user($userData);
        
        $this->assertTrue($result);
        $this->assertIsInt($this->user->get_user_id());
    }

    public function testEmailValidation(): void
    {
        $validEmail = 'test@example.com';
        $invalidEmail = 'invalid-email';

        $this->assertTrue($this->user->validate_email($validEmail));
        $this->assertFalse($this->user->validate_email($invalidEmail));
    }
}
```

**Jest Tests (JavaScript):**
```javascript
describe('ExampleModule', function() {
    let module;

    beforeEach(function() {
        module = new ExampleModule();
    });

    it('should initialize correctly', function() {
        expect(module).toBeDefined();
        expect(typeof module.init).toBe('function');
    });

    it('should handle button clicks', function() {
        const button = $('<button class="example-button">Click me</button>');
        $('body').append(button);

        spyOn(console, 'log');
        module.handleClick({ preventDefault: jasmine.createSpy() });
        
        expect(console.log).toHaveBeenCalledWith('Button clicked');
    });
});
```

### Integration Testing

**API Testing:**
```php
<?php

namespace Tests\Integration;

use PHPUnit\Framework\TestCase;
use GuzzleHttp\Client;

class ApiTest extends TestCase
{
    private Client $client;
    private string $baseUrl;

    protected function setUp(): void
    {
        $this->client = new Client();
        $this->baseUrl = 'http://localhost/apis/php';
    }

    public function testUserRegistration(): void
    {
        $response = $this->client->post($this->baseUrl . '/auth/register', [
            'json' => [
                'user_name' => 'testuser',
                'user_email' => 'test@example.com',
                'user_password' => 'password123'
            ]
        ]);

        $this->assertEquals(200, $response->getStatusCode());
        
        $data = json_decode($response->getBody(), true);
        $this->assertTrue($data['success']);
    }
}
```

### Test Coverage

**Minimum Coverage Requirements:**
- Unit tests: 80%
- Integration tests: 60%
- Critical paths: 95%

**Running Tests:**
```bash
# Run all tests
composer test

# Run specific test suite
composer test:unit
composer test:integration

# Generate coverage report
composer test:coverage
```

## Documentation

### Code Documentation

**PHPDoc Standards:**
```php
/**
 * User management class
 *
 * This class handles all user-related operations including
 * registration, authentication, and profile management.
 *
 * @package Rechain\DAO
 * @author Your Name <your.email@example.com>
 * @since 1.0.0
 */
class User
{
    /**
     * User ID
     *
     * @var int
     */
    private int $user_id;

    /**
     * User data array
     *
     * @var array
     */
    private array $user_data = [];

    /**
     * Create a new user
     *
     * @param array $data User data including name, email, password
     * @return bool True on success, false on failure
     * @throws InvalidArgumentException If required data is missing
     * @throws DatabaseException If database operation fails
     * @since 1.0.0
     */
    public function create_user(array $data): bool
    {
        // Implementation
    }
}
```

### README Updates

**When updating README:**
- Keep it concise and clear
- Include installation instructions
- Add usage examples
- Update version information
- Include contribution guidelines

### API Documentation

**Document all API endpoints:**
- HTTP method and URL
- Request parameters
- Response format
- Error codes
- Example requests/responses

## Community Guidelines

### Communication Channels

**Primary Channels:**
- **GitHub Issues**: Bug reports and feature requests
- **GitHub Discussions**: General discussions and questions
- **Discord**: Real-time chat and community support
- **Email**: support@rechain.network

**Communication Best Practices:**
- Be respectful and professional
- Use clear, descriptive language
- Search before asking questions
- Provide context and examples
- Be patient with responses

### Getting Help

**Before asking for help:**
1. Check the documentation
2. Search existing issues
3. Try to reproduce the problem
4. Gather relevant information

**When asking for help:**
- Provide clear problem description
- Include error messages and logs
- Share relevant code snippets
- Specify your environment
- Show what you've already tried

### Mentoring

**For New Contributors:**
- Start with documentation or small bug fixes
- Ask questions in Discord or GitHub Discussions
- Look for "good first issue" labels
- Don't hesitate to ask for help

**For Experienced Contributors:**
- Help newcomers get started
- Review pull requests thoroughly
- Share knowledge and best practices
- Be patient with learning processes

## Release Process

### Version Numbering

We use **Semantic Versioning** (SemVer):
- **MAJOR**: Incompatible API changes
- **MINOR**: New functionality (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

**Examples:**
- `1.0.0` - Initial release
- `1.1.0` - New features added
- `1.1.1` - Bug fixes
- `2.0.0` - Breaking changes

### Release Schedule

**Regular Releases:**
- **Major releases**: Every 6 months
- **Minor releases**: Every 2 months
- **Patch releases**: As needed

**Release Process:**
1. Create release branch from `develop`
2. Update version numbers
3. Update changelog
4. Run full test suite
5. Create release notes
6. Tag release
7. Merge to `main`
8. Deploy to production

### Changelog

**Keep changelog updated:**
```markdown
# Changelog

## [1.1.0] - 2024-01-15

### Added
- Two-factor authentication support
- New API endpoints for user management
- Dark theme option

### Changed
- Improved login performance
- Updated user interface components

### Fixed
- Fixed password reset email issue
- Resolved mobile app crash on Android

### Security
- Enhanced password hashing
- Fixed XSS vulnerability in comments
```

## Recognition

### Contributor Recognition

**We recognize contributors through:**
- **Contributors list** in README
- **Release notes** acknowledgments
- **Community highlights** in Discord
- **Special badges** for significant contributions
- **Swag and merchandise** for top contributors

### Contribution Levels

**Bronze Contributor** (1-5 contributions):
- Bug fixes
- Documentation updates
- Small feature additions

**Silver Contributor** (6-20 contributions):
- Major feature development
- Significant bug fixes
- Code reviews and mentoring

**Gold Contributor** (21+ contributions):
- Core feature development
- Architecture improvements
- Community leadership

### Hall of Fame

**Special recognition for:**
- Long-term contributors
- Community leaders
- Security researchers
- Documentation champions
- Translation contributors

---

## Quick Reference

### Essential Commands

```bash
# Setup
git clone https://github.com/YOUR_USERNAME/DAO.git
cd DAO
composer install
npm install

# Development
git checkout -b feature/your-feature
# Make changes
composer test
git add .
git commit -m "feat: your feature description"
git push origin feature/your-feature

# Create PR on GitHub
```

### Important Links

- **Repository**: https://github.com/REChain-Network-Solutions/DAO
- **Issues**: https://github.com/REChain-Network-Solutions/DAO/issues
- **Discussions**: https://github.com/REChain-Network-Solutions/DAO/discussions
- **Discord**: https://discord.gg/rechain-dao
- **Documentation**: https://docs.rechain.network

### Contact

- **Email**: contributors@rechain.network
- **Discord**: @rechain-team
- **Twitter**: @REChainNetwork

---

**Thank you for contributing to REChain DAO! Together, we're building the future of decentralized social networking.** 🚀
