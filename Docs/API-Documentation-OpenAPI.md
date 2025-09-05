# API Documentation (OpenAPI/Swagger)

## Overview

This document provides comprehensive OpenAPI/Swagger documentation for the REChain DAO platform API, including all endpoints, request/response schemas, authentication, and examples.

## Table of Contents

1. [API Overview](#api-overview)
2. [Authentication](#authentication)
3. [Endpoints](#endpoints)
4. [Schemas](#schemas)
5. [Examples](#examples)
6. [Error Handling](#error-handling)

## API Overview

### OpenAPI Specification
```yaml
openapi: 3.0.3
info:
  title: REChain DAO API
  description: |
    The REChain DAO API provides comprehensive access to the decentralized autonomous organization platform.
    This API allows users to interact with the platform, manage their accounts, participate in governance,
    and access various platform features.
  version: 1.0.0
  contact:
    name: REChain DAO Support
    email: support@rechain-dao.com
    url: https://rechain-dao.com/support
  license:
    name: MIT
    url: https://opensource.org/licenses/MIT
  termsOfService: https://rechain-dao.com/terms

servers:
  - url: https://api.rechain-dao.com/v1
    description: Production server
  - url: https://staging-api.rechain-dao.com/v1
    description: Staging server
  - url: http://localhost:8000/api/v1
    description: Development server

paths:
  /health:
    get:
      summary: Health Check
      description: Check the health status of the API
      operationId: healthCheck
      tags:
        - System
      responses:
        '200':
          description: API is healthy
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/HealthResponse'
        '500':
          description: API is unhealthy
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /auth/login:
    post:
      summary: User Login
      description: Authenticate a user and return access token
      operationId: login
      tags:
        - Authentication
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/LoginRequest'
      responses:
        '200':
          description: Login successful
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/LoginResponse'
        '401':
          description: Invalid credentials
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '429':
          description: Too many login attempts
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /auth/register:
    post:
      summary: User Registration
      description: Register a new user account
      operationId: register
      tags:
        - Authentication
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/RegisterRequest'
      responses:
        '201':
          description: User registered successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/RegisterResponse'
        '400':
          description: Invalid registration data
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '409':
          description: User already exists
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /users/{userId}:
    get:
      summary: Get User Profile
      description: Retrieve user profile information
      operationId: getUserProfile
      tags:
        - Users
      security:
        - bearerAuth: []
      parameters:
        - name: userId
          in: path
          required: true
          description: User ID
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: User profile retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserProfile'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '404':
          description: User not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

    put:
      summary: Update User Profile
      description: Update user profile information
      operationId: updateUserProfile
      tags:
        - Users
      security:
        - bearerAuth: []
      parameters:
        - name: userId
          in: path
          required: true
          description: User ID
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateUserRequest'
      responses:
        '200':
          description: User profile updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/UserProfile'
        '400':
          description: Invalid update data
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '404':
          description: User not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /proposals:
    get:
      summary: List Proposals
      description: Retrieve a list of governance proposals
      operationId: listProposals
      tags:
        - Governance
      security:
        - bearerAuth: []
      parameters:
        - name: status
          in: query
          description: Filter by proposal status
          schema:
            type: string
            enum: [draft, active, passed, rejected, expired]
        - name: limit
          in: query
          description: Number of proposals to return
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 20
        - name: offset
          in: query
          description: Number of proposals to skip
          schema:
            type: integer
            minimum: 0
            default: 0
      responses:
        '200':
          description: Proposals retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ProposalListResponse'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

    post:
      summary: Create Proposal
      description: Create a new governance proposal
      operationId: createProposal
      tags:
        - Governance
      security:
        - bearerAuth: []
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateProposalRequest'
      responses:
        '201':
          description: Proposal created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Proposal'
        '400':
          description: Invalid proposal data
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /proposals/{proposalId}:
    get:
      summary: Get Proposal
      description: Retrieve a specific proposal
      operationId: getProposal
      tags:
        - Governance
      security:
        - bearerAuth: []
      parameters:
        - name: proposalId
          in: path
          required: true
          description: Proposal ID
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Proposal retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Proposal'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '404':
          description: Proposal not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

    put:
      summary: Update Proposal
      description: Update a proposal (only if in draft status)
      operationId: updateProposal
      tags:
        - Governance
      security:
        - bearerAuth: []
      parameters:
        - name: proposalId
          in: path
          required: true
          description: Proposal ID
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/UpdateProposalRequest'
      responses:
        '200':
          description: Proposal updated successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Proposal'
        '400':
          description: Invalid update data
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '404':
          description: Proposal not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '409':
          description: Proposal cannot be updated
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /proposals/{proposalId}/vote:
    post:
      summary: Vote on Proposal
      description: Cast a vote on a proposal
      operationId: voteOnProposal
      tags:
        - Governance
      security:
        - bearerAuth: []
      parameters:
        - name: proposalId
          in: path
          required: true
          description: Proposal ID
          schema:
            type: string
            format: uuid
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/VoteRequest'
      responses:
        '200':
          description: Vote cast successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/VoteResponse'
        '400':
          description: Invalid vote data
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '404':
          description: Proposal not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '409':
          description: Vote already cast or proposal not active
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /tokens:
    get:
      summary: List Tokens
      description: Retrieve a list of available tokens
      operationId: listTokens
      tags:
        - Tokens
      security:
        - bearerAuth: []
      parameters:
        - name: limit
          in: query
          description: Number of tokens to return
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 20
        - name: offset
          in: query
          description: Number of tokens to skip
          schema:
            type: integer
            minimum: 0
            default: 0
      responses:
        '200':
          description: Tokens retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TokenListResponse'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /tokens/{tokenId}:
    get:
      summary: Get Token
      description: Retrieve a specific token
      operationId: getToken
      tags:
        - Tokens
      security:
        - bearerAuth: []
      parameters:
        - name: tokenId
          in: path
          required: true
          description: Token ID
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Token retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Token'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '404':
          description: Token not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /wallets/{walletId}:
    get:
      summary: Get Wallet
      description: Retrieve wallet information
      operationId: getWallet
      tags:
        - Wallets
      security:
        - bearerAuth: []
      parameters:
        - name: walletId
          in: path
          required: true
          description: Wallet ID
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: Wallet retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Wallet'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '404':
          description: Wallet not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

  /wallets/{walletId}/transactions:
    get:
      summary: List Wallet Transactions
      description: Retrieve wallet transaction history
      operationId: listWalletTransactions
      tags:
        - Wallets
      security:
        - bearerAuth: []
      parameters:
        - name: walletId
          in: path
          required: true
          description: Wallet ID
          schema:
            type: string
            format: uuid
        - name: limit
          in: query
          description: Number of transactions to return
          schema:
            type: integer
            minimum: 1
            maximum: 100
            default: 20
        - name: offset
          in: query
          description: Number of transactions to skip
          schema:
            type: integer
            minimum: 0
            default: 0
      responses:
        '200':
          description: Transactions retrieved successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/TransactionListResponse'
        '401':
          description: Unauthorized
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'
        '404':
          description: Wallet not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/ErrorResponse'

components:
  securitySchemes:
    bearerAuth:
      type: http
      scheme: bearer
      bearerFormat: JWT
    apiKey:
      type: apiKey
      in: header
      name: X-API-Key

  schemas:
    HealthResponse:
      type: object
      properties:
        status:
          type: string
          enum: [healthy, unhealthy]
        timestamp:
          type: string
          format: date-time
        version:
          type: string
        uptime:
          type: integer
          description: Uptime in seconds

    ErrorResponse:
      type: object
      properties:
        error:
          type: string
        message:
          type: string
        code:
          type: integer
        timestamp:
          type: string
          format: date-time
        details:
          type: object
          additionalProperties: true

    LoginRequest:
      type: object
      required:
        - email
        - password
      properties:
        email:
          type: string
          format: email
        password:
          type: string
          minLength: 8
        remember_me:
          type: boolean
          default: false

    LoginResponse:
      type: object
      properties:
        access_token:
          type: string
        refresh_token:
          type: string
        token_type:
          type: string
          default: Bearer
        expires_in:
          type: integer
          description: Token expiration time in seconds
        user:
          $ref: '#/components/schemas/UserProfile'

    RegisterRequest:
      type: object
      required:
        - username
        - email
        - password
        - confirm_password
      properties:
        username:
          type: string
          minLength: 3
          maxLength: 50
        email:
          type: string
          format: email
        password:
          type: string
          minLength: 8
        confirm_password:
          type: string
          minLength: 8
        first_name:
          type: string
          maxLength: 100
        last_name:
          type: string
          maxLength: 100
        terms_accepted:
          type: boolean
          default: false

    RegisterResponse:
      type: object
      properties:
        user_id:
          type: string
          format: uuid
        username:
          type: string
        email:
          type: string
        message:
          type: string

    UserProfile:
      type: object
      properties:
        id:
          type: string
          format: uuid
        username:
          type: string
        email:
          type: string
        first_name:
          type: string
        last_name:
          type: string
        avatar:
          type: string
          format: uri
        bio:
          type: string
        location:
          type: string
        website:
          type: string
          format: uri
        created_at:
          type: string
          format: date-time
        updated_at:
          type: string
          format: date-time
        is_verified:
          type: boolean
        is_active:
          type: boolean

    UpdateUserRequest:
      type: object
      properties:
        first_name:
          type: string
          maxLength: 100
        last_name:
          type: string
          maxLength: 100
        bio:
          type: string
          maxLength: 500
        location:
          type: string
          maxLength: 100
        website:
          type: string
          format: uri

    Proposal:
      type: object
      properties:
        id:
          type: string
          format: uuid
        title:
          type: string
        description:
          type: string
        status:
          type: string
          enum: [draft, active, passed, rejected, expired]
        proposer:
          $ref: '#/components/schemas/UserProfile'
        created_at:
          type: string
          format: date-time
        updated_at:
          type: string
          format: date-time
        voting_start:
          type: string
          format: date-time
        voting_end:
          type: string
          format: date-time
        votes_for:
          type: integer
        votes_against:
          type: integer
        total_votes:
          type: integer
        quorum:
          type: integer
        execution_delay:
          type: integer
          description: Execution delay in hours

    CreateProposalRequest:
      type: object
      required:
        - title
        - description
        - voting_duration
      properties:
        title:
          type: string
          minLength: 10
          maxLength: 200
        description:
          type: string
          minLength: 50
          maxLength: 5000
        voting_duration:
          type: integer
          minimum: 1
          maximum: 168
          description: Voting duration in hours
        execution_delay:
          type: integer
          minimum: 0
          maximum: 168
          description: Execution delay in hours
        tags:
          type: array
          items:
            type: string
          maxItems: 10

    UpdateProposalRequest:
      type: object
      properties:
        title:
          type: string
          minLength: 10
          maxLength: 200
        description:
          type: string
          minLength: 50
          maxLength: 5000
        tags:
          type: array
          items:
            type: string
          maxItems: 10

    ProposalListResponse:
      type: object
      properties:
        proposals:
          type: array
          items:
            $ref: '#/components/schemas/Proposal'
        total:
          type: integer
        limit:
          type: integer
        offset:
          type: integer

    VoteRequest:
      type: object
      required:
        - vote
      properties:
        vote:
          type: string
          enum: [for, against, abstain]
        reason:
          type: string
          maxLength: 500

    VoteResponse:
      type: object
      properties:
        vote_id:
          type: string
          format: uuid
        proposal_id:
          type: string
          format: uuid
        voter:
          $ref: '#/components/schemas/UserProfile'
        vote:
          type: string
          enum: [for, against, abstain]
        reason:
          type: string
        timestamp:
          type: string
          format: date-time

    Token:
      type: object
      properties:
        id:
          type: string
          format: uuid
        symbol:
          type: string
        name:
          type: string
        decimals:
          type: integer
        total_supply:
          type: string
        circulating_supply:
          type: string
        contract_address:
          type: string
        network:
          type: string
        created_at:
          type: string
          format: date-time

    TokenListResponse:
      type: object
      properties:
        tokens:
          type: array
          items:
            $ref: '#/components/schemas/Token'
        total:
          type: integer
        limit:
          type: integer
        offset:
          type: integer

    Wallet:
      type: object
      properties:
        id:
          type: string
          format: uuid
        address:
          type: string
        network:
          type: string
        balance:
          type: string
        tokens:
          type: array
          items:
            $ref: '#/components/schemas/TokenBalance'
        created_at:
          type: string
          format: date-time

    TokenBalance:
      type: object
      properties:
        token:
          $ref: '#/components/schemas/Token'
        balance:
          type: string
        value_usd:
          type: number

    Transaction:
      type: object
      properties:
        id:
          type: string
          format: uuid
        hash:
          type: string
        from_address:
          type: string
        to_address:
          type: string
        amount:
          type: string
        token:
          $ref: '#/components/schemas/Token'
        status:
          type: string
          enum: [pending, confirmed, failed]
        gas_used:
          type: string
        gas_price:
          type: string
        block_number:
          type: integer
        timestamp:
          type: string
          format: date-time

    TransactionListResponse:
      type: object
      properties:
        transactions:
          type: array
          items:
            $ref: '#/components/schemas/Transaction'
        total:
          type: integer
        limit:
          type: integer
        offset:
          type: integer

security:
  - bearerAuth: []
  - apiKey: []
```

## Examples

### Authentication Example
```bash
# Login
curl -X POST "https://api.rechain-dao.com/v1/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123",
    "remember_me": true
  }'

# Response
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "Bearer",
  "expires_in": 3600,
  "user": {
    "id": "123e4567-e89b-12d3-a456-426614174000",
    "username": "johndoe",
    "email": "user@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "avatar": "https://api.rechain-dao.com/avatars/johndoe.jpg",
    "bio": "Blockchain enthusiast",
    "location": "New York, NY",
    "website": "https://johndoe.com",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z",
    "is_verified": true,
    "is_active": true
  }
}
```

### Governance Example
```bash
# Create Proposal
curl -X POST "https://api.rechain-dao.com/v1/proposals" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Increase DAO Treasury Allocation",
    "description": "This proposal suggests increasing the DAO treasury allocation from 10% to 15% to fund more community initiatives and development projects.",
    "voting_duration": 72,
    "execution_delay": 24,
    "tags": ["treasury", "governance", "funding"]
  }'

# Vote on Proposal
curl -X POST "https://api.rechain-dao.com/v1/proposals/123e4567-e89b-12d3-a456-426614174000/vote" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "vote": "for",
    "reason": "I believe this will help fund important community projects and drive growth."
  }'
```

### Wallet Example
```bash
# Get Wallet
curl -X GET "https://api.rechain-dao.com/v1/wallets/123e4567-e89b-12d3-a456-426614174000" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."

# Response
{
  "id": "123e4567-e89b-12d3-a456-426614174000",
  "address": "0x742d35Cc6634C0532925a3b8D4C9db96C4b4d8b6",
  "network": "ethereum",
  "balance": "1.5",
  "tokens": [
    {
      "token": {
        "id": "456e7890-e89b-12d3-a456-426614174001",
        "symbol": "RCH",
        "name": "REChain Token",
        "decimals": 18,
        "total_supply": "1000000000",
        "circulating_supply": "500000000",
        "contract_address": "0x1234567890abcdef1234567890abcdef12345678",
        "network": "ethereum",
        "created_at": "2024-01-01T00:00:00Z"
      },
      "balance": "1000.0",
      "value_usd": 5000.0
    }
  ],
  "created_at": "2024-01-01T00:00:00Z"
}
```

## Error Handling

### Error Codes
```yaml
error_codes:
  400:
    - INVALID_REQUEST: "Invalid request data"
    - VALIDATION_ERROR: "Data validation failed"
    - MISSING_FIELD: "Required field is missing"
    - INVALID_FORMAT: "Invalid data format"
  
  401:
    - UNAUTHORIZED: "Authentication required"
    - INVALID_TOKEN: "Invalid or expired token"
    - TOKEN_EXPIRED: "Token has expired"
    - INVALID_CREDENTIALS: "Invalid login credentials"
  
  403:
    - FORBIDDEN: "Access denied"
    - INSUFFICIENT_PERMISSIONS: "Insufficient permissions"
    - ACCOUNT_SUSPENDED: "Account is suspended"
    - RATE_LIMITED: "Rate limit exceeded"
  
  404:
    - NOT_FOUND: "Resource not found"
    - USER_NOT_FOUND: "User not found"
    - PROPOSAL_NOT_FOUND: "Proposal not found"
    - WALLET_NOT_FOUND: "Wallet not found"
  
  409:
    - CONFLICT: "Resource conflict"
    - USER_EXISTS: "User already exists"
    - VOTE_ALREADY_CAST: "Vote already cast"
    - PROPOSAL_NOT_EDITABLE: "Proposal cannot be edited"
  
  429:
    - TOO_MANY_REQUESTS: "Too many requests"
    - RATE_LIMIT_EXCEEDED: "Rate limit exceeded"
    - LOGIN_ATTEMPTS_EXCEEDED: "Too many login attempts"
  
  500:
    - INTERNAL_ERROR: "Internal server error"
    - DATABASE_ERROR: "Database error"
    - EXTERNAL_SERVICE_ERROR: "External service error"
    - BLOCKCHAIN_ERROR: "Blockchain error"
```

### Error Response Format
```json
{
  "error": "VALIDATION_ERROR",
  "message": "Data validation failed",
  "code": 400,
  "timestamp": "2024-01-01T00:00:00Z",
  "details": {
    "field": "email",
    "reason": "Invalid email format",
    "value": "invalid-email"
  }
}
```

## Conclusion

This OpenAPI/Swagger documentation provides comprehensive coverage of the REChain DAO API, including all endpoints, request/response schemas, authentication methods, and error handling. It serves as a complete reference for developers integrating with the platform.

Remember: Always use the latest version of the API documentation and test your integrations thoroughly before deploying to production. The API may be updated periodically, so check for changes regularly.
