# Contributing to REChain DAO Platform

Thank you for your interest in contributing to the REChain DAO Platform! This document provides guidelines and information for contributors.

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

- Node.js 18+
- MySQL 8.0+
- Redis 6.0+
- Git
- Docker (optional)

### Setting Up Development Environment

1. **Fork the repository**
   - Click the "Fork" button on GitHub
   - Clone your fork locally

2. **Clone your fork**
   ```bash
   git clone https://github.com/your-username/rechain-dao.git
   cd rechain-dao
   ```

3. **Add upstream remote**
   ```bash
   git remote add upstream https://github.com/original-username/rechain-dao.git
   ```

4. **Install dependencies**
   ```bash
   npm install
   ```

5. **Set up environment**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

6. **Set up database**
   ```bash
   npm run db:migrate
   npm run db:seed
   ```

7. **Start development server**
   ```bash
   npm run dev
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
   npm test
   npm run lint
   npm run type-check
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
   - Type checking must pass

2. **Code review**
   - At least one approval required
   - Address all review comments
   - Update PR based on feedback

3. **Merge**
   - Squash and merge for feature branches
   - Merge commit for release branches
   - Delete feature branch after merge

## Coding Standards

### JavaScript/TypeScript

- Use TypeScript for new code
- Follow ESLint configuration
- Use Prettier for formatting
- Write meaningful variable and function names
- Add JSDoc comments for public APIs

```typescript
/**
 * Creates a new proposal in the DAO
 * @param proposalData - The proposal data
 * @param userId - The ID of the user creating the proposal
 * @returns Promise<Proposal> - The created proposal
 */
async function createProposal(proposalData: ProposalData, userId: string): Promise<Proposal> {
  // Implementation
}
```

### React Components

- Use functional components with hooks
- Use TypeScript interfaces for props
- Follow component naming conventions
- Keep components small and focused

```typescript
interface ProposalCardProps {
  proposal: Proposal;
  onVote: (proposalId: string, vote: VoteType) => void;
}

const ProposalCard: React.FC<ProposalCardProps> = ({ proposal, onVote }) => {
  // Component implementation
};
```

### Database

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
   - Test individual functions and components
   - Use Jest and React Testing Library
   - Aim for high coverage

2. **Integration Tests**
   - Test API endpoints
   - Test database interactions
   - Test external service integrations

3. **End-to-End Tests**
   - Test complete user workflows
   - Use Cypress for browser testing
   - Test critical user paths

### Writing Tests

```typescript
// Unit test example
describe('ProposalService', () => {
  it('should create a proposal with valid data', async () => {
    const proposalData = {
      title: 'Test Proposal',
      description: 'Test Description',
      type: 'governance'
    };
    
    const proposal = await proposalService.create(proposalData, 'user123');
    
    expect(proposal).toBeDefined();
    expect(proposal.title).toBe(proposalData.title);
  });
});
```

### Running Tests

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run tests with coverage
npm run test:coverage

# Run specific test file
npm test -- ProposalService.test.ts

# Run E2E tests
npm run test:e2e
```

## Documentation

### Code Documentation

- Add JSDoc comments for functions and classes
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
4. **Environment details** (OS, browser, Node.js version)
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
- **Discord** - Real-time chat and support
- **Email** - support@rechain-dao.com

## Recognition

Contributors will be recognized in:

- CONTRIBUTORS.md file
- Release notes
- Project documentation
- Community acknowledgments

## Thank You

Thank you for contributing to the REChain DAO Platform! Your contributions help make decentralized governance more accessible and effective for communities worldwide.

---

**Happy Contributing! 🚀**
