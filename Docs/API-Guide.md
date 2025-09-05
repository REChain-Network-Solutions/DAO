# API Guide

## Overview

This guide provides comprehensive documentation for the REChain DAO Platform API, including authentication, endpoints, request/response formats, and examples.

## Table of Contents

1. [Authentication](#authentication)
2. [Base URL](#base-url)
3. [Response Format](#response-format)
4. [Error Handling](#error-handling)
5. [Rate Limiting](#rate-limiting)
6. [Endpoints](#endpoints)
7. [Examples](#examples)

## Authentication

### JWT Token

The API uses JWT (JSON Web Token) for authentication. Include the token in the Authorization header:

```http
Authorization: Bearer <your-jwt-token>
```

### Getting a Token

```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "user-id",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "user"
    }
  }
}
```

## Base URL

- **Production**: `https://api.rechain-dao.com/v1`
- **Staging**: `https://staging-api.rechain-dao.com/v1`
- **Development**: `http://localhost:3000/v1`

## Response Format

### Success Response

```json
{
  "success": true,
  "data": {
    // Response data
  },
  "message": "Operation completed successfully",
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

### Error Response

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request data",
    "details": [
      {
        "field": "email",
        "message": "Email is required"
      }
    ]
  },
  "timestamp": "2024-01-01T00:00:00.000Z"
}
```

## Error Handling

### HTTP Status Codes

| Code | Description |
|------|-------------|
| 200 | OK |
| 201 | Created |
| 400 | Bad Request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not Found |
| 422 | Unprocessable Entity |
| 429 | Too Many Requests |
| 500 | Internal Server Error |

### Error Codes

| Code | Description |
|------|-------------|
| `VALIDATION_ERROR` | Input validation failed |
| `AUTHENTICATION_ERROR` | Invalid credentials |
| `AUTHORIZATION_ERROR` | Insufficient permissions |
| `NOT_FOUND` | Resource not found |
| `DUPLICATE_ERROR` | Resource already exists |
| `RATE_LIMIT_ERROR` | Rate limit exceeded |
| `SERVER_ERROR` | Internal server error |

## Rate Limiting

- **General API**: 100 requests per 15 minutes
- **Authentication**: 5 requests per 15 minutes
- **File Upload**: 10 requests per 15 minutes

Rate limit headers:
```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1640995200
```

## Endpoints

### Authentication

#### POST /api/auth/register

Register a new user.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "firstName": "John",
  "lastName": "Doe"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "user-id",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "user",
      "createdAt": "2024-01-01T00:00:00.000Z"
    }
  }
}
```

#### POST /api/auth/login

Authenticate user and get token.

**Request:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "id": "user-id",
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "role": "user"
    }
  }
}
```

#### POST /api/auth/logout

Logout user and invalidate token.

**Headers:**
```http
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

### Users

#### GET /api/users/profile

Get current user profile.

**Headers:**
```http
Authorization: Bearer <token>
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "user-id",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "role": "user",
    "profile": {
      "bio": "Software developer",
      "avatar": "https://example.com/avatar.jpg",
      "website": "https://johndoe.com"
    },
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

#### PUT /api/users/profile

Update user profile.

**Headers:**
```http
Authorization: Bearer <token>
```

**Request:**
```json
{
  "firstName": "John",
  "lastName": "Doe",
  "profile": {
    "bio": "Updated bio",
    "website": "https://newwebsite.com"
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "user-id",
    "email": "user@example.com",
    "firstName": "John",
    "lastName": "Doe",
    "profile": {
      "bio": "Updated bio",
      "website": "https://newwebsite.com"
    },
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

### Proposals

#### GET /api/proposals

Get list of proposals.

**Query Parameters:**
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 20)
- `status` (string): Filter by status (draft, active, passed, rejected, expired)
- `type` (string): Filter by type (governance, treasury, technical, social)
- `search` (string): Search in title and description

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "proposal-id",
      "title": "Proposal Title",
      "description": "Proposal description",
      "type": "governance",
      "status": "active",
      "proposer": {
        "id": "user-id",
        "firstName": "John",
        "lastName": "Doe"
      },
      "votingStart": "2024-01-01T00:00:00.000Z",
      "votingEnd": "2024-01-07T00:00:00.000Z",
      "totalVotes": 150,
      "yesVotes": 120,
      "noVotes": 30,
      "createdAt": "2024-01-01T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "pages": 5
  }
}
```

#### GET /api/proposals/:id

Get proposal by ID.

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "proposal-id",
    "title": "Proposal Title",
    "description": "Detailed proposal description",
    "type": "governance",
    "status": "active",
    "proposer": {
      "id": "user-id",
      "firstName": "John",
      "lastName": "Doe",
      "profile": {
        "avatar": "https://example.com/avatar.jpg"
      }
    },
    "votingStart": "2024-01-01T00:00:00.000Z",
    "votingEnd": "2024-01-07T00:00:00.000Z",
    "totalVotes": 150,
    "yesVotes": 120,
    "noVotes": 30,
    "abstainVotes": 0,
    "comments": [
      {
        "id": "comment-id",
        "content": "Great proposal!",
        "author": {
          "id": "user-id",
          "firstName": "Jane",
          "lastName": "Smith"
        },
        "createdAt": "2024-01-02T00:00:00.000Z"
      }
    ],
    "createdAt": "2024-01-01T00:00:00.000Z",
    "updatedAt": "2024-01-01T00:00:00.000Z"
  }
}
```

#### POST /api/proposals

Create a new proposal.

**Headers:**
```http
Authorization: Bearer <token>
```

**Request:**
```json
{
  "title": "Proposal Title",
  "description": "Detailed proposal description",
  "type": "governance",
  "votingStart": "2024-01-01T00:00:00.000Z",
  "votingEnd": "2024-01-07T00:00:00.000Z"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "proposal-id",
    "title": "Proposal Title",
    "description": "Detailed proposal description",
    "type": "governance",
    "status": "draft",
    "proposerId": "user-id",
    "votingStart": "2024-01-01T00:00:00.000Z",
    "votingEnd": "2024-01-07T00:00:00.000Z",
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
}
```

### Votes

#### POST /api/votes

Cast a vote on a proposal.

**Headers:**
```http
Authorization: Bearer <token>
```

**Request:**
```json
{
  "proposalId": "proposal-id",
  "voteType": "yes",
  "reason": "I support this proposal because..."
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "vote-id",
    "proposalId": "proposal-id",
    "voterId": "user-id",
    "voteType": "yes",
    "reason": "I support this proposal because...",
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
}
```

#### GET /api/votes

Get user's votes.

**Headers:**
```http
Authorization: Bearer <token>
```

**Query Parameters:**
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 20)
- `proposalId` (string): Filter by proposal ID

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "vote-id",
      "proposalId": "proposal-id",
      "proposal": {
        "title": "Proposal Title",
        "status": "active"
      },
      "voteType": "yes",
      "reason": "I support this proposal",
      "createdAt": "2024-01-01T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 50,
    "pages": 3
  }
}
```

### Comments

#### POST /api/comments

Add a comment to a proposal.

**Headers:**
```http
Authorization: Bearer <token>
```

**Request:**
```json
{
  "proposalId": "proposal-id",
  "content": "This is a great proposal!",
  "parentId": "parent-comment-id" // Optional, for replies
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "comment-id",
    "proposalId": "proposal-id",
    "authorId": "user-id",
    "content": "This is a great proposal!",
    "parentId": "parent-comment-id",
    "likes": 0,
    "dislikes": 0,
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
}
```

#### GET /api/comments

Get comments for a proposal.

**Query Parameters:**
- `proposalId` (string): Proposal ID (required)
- `page` (number): Page number (default: 1)
- `limit` (number): Items per page (default: 20)

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "comment-id",
      "proposalId": "proposal-id",
      "author": {
        "id": "user-id",
        "firstName": "John",
        "lastName": "Doe",
        "profile": {
          "avatar": "https://example.com/avatar.jpg"
        }
      },
      "content": "This is a great proposal!",
      "parentId": null,
      "likes": 5,
      "dislikes": 1,
      "replies": [
        {
          "id": "reply-id",
          "author": {
            "id": "user-id-2",
            "firstName": "Jane",
            "lastName": "Smith"
          },
          "content": "I agree!",
          "likes": 2,
          "dislikes": 0,
          "createdAt": "2024-01-01T00:00:00.000Z"
        }
      ],
      "createdAt": "2024-01-01T00:00:00.000Z"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "pages": 5
  }
}
```

## Examples

### Complete Workflow

```javascript
// 1. Register user
const registerResponse = await fetch('https://api.rechain-dao.com/v1/api/auth/register', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    email: 'user@example.com',
    password: 'password123',
    firstName: 'John',
    lastName: 'Doe'
  })
});

const { data: { user } } = await registerResponse.json();

// 2. Login to get token
const loginResponse = await fetch('https://api.rechain-dao.com/v1/api/auth/login', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json'
  },
  body: JSON.stringify({
    email: 'user@example.com',
    password: 'password123'
  })
});

const { data: { token } } = await loginResponse.json();

// 3. Create proposal
const proposalResponse = await fetch('https://api.rechain-dao.com/v1/api/proposals', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify({
    title: 'New Feature Proposal',
    description: 'I propose adding a new feature to improve user experience.',
    type: 'governance',
    votingStart: new Date().toISOString(),
    votingEnd: new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString()
  })
});

const { data: proposal } = await proposalResponse.json();

// 4. Vote on proposal
const voteResponse = await fetch('https://api.rechain-dao.com/v1/api/votes', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${token}`
  },
  body: JSON.stringify({
    proposalId: proposal.id,
    voteType: 'yes',
    reason: 'I support this proposal'
  })
});

// 5. Get proposal with updated vote count
const updatedProposalResponse = await fetch(`https://api.rechain-dao.com/v1/api/proposals/${proposal.id}`, {
  headers: {
    'Authorization': `Bearer ${token}`
  }
});

const { data: updatedProposal } = await updatedProposalResponse.json();
console.log('Updated proposal:', updatedProposal);
```

### Error Handling

```javascript
async function makeAPICall() {
  try {
    const response = await fetch('https://api.rechain-dao.com/v1/api/proposals', {
      headers: {
        'Authorization': `Bearer ${token}`
      }
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error.message);
    }

    const data = await response.json();
    return data;
  } catch (error) {
    console.error('API Error:', error.message);
    throw error;
  }
}
```

## Conclusion

This API guide provides comprehensive documentation for the REChain DAO Platform API. For additional support, please refer to our [documentation](docs/) or contact our [support team](mailto:support@rechain-dao.com).
