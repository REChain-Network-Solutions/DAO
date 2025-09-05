# System Architecture Diagrams

## Overview

This document provides comprehensive system architecture diagrams for the REChain DAO platform, including high-level architecture, component interactions, data flow, and deployment diagrams.

## Table of Contents

1. [High-Level Architecture](#high-level-architecture)
2. [Component Architecture](#component-architecture)
3. [Data Flow Diagrams](#data-flow-diagrams)
4. [Deployment Architecture](#deployment-architecture)
5. [Security Architecture](#security-architecture)
6. [Network Architecture](#network-architecture)

## High-Level Architecture

### System Overview
```mermaid
graph TB
    subgraph "Client Layer"
        WEB[Web Application]
        MOBILE[Mobile App]
        API_CLIENT[API Client]
    end
    
    subgraph "Load Balancer"
        LB[Load Balancer]
    end
    
    subgraph "Application Layer"
        API[API Gateway]
        AUTH[Authentication Service]
        GOV[Governance Service]
        WALLET[Wallet Service]
        USER[User Service]
    end
    
    subgraph "Business Logic Layer"
        DAO[DAO Logic]
        VOTING[Voting Engine]
        TOKEN[Token Management]
        PROPOSAL[Proposal Management]
    end
    
    subgraph "Data Layer"
        DB[(Database)]
        CACHE[(Cache)]
        FILES[(File Storage)]
    end
    
    subgraph "Blockchain Layer"
        ETH[Ethereum Network]
        SMART_CONTRACTS[Smart Contracts]
    end
    
    subgraph "External Services"
        EMAIL[Email Service]
        SMS[SMS Service]
        ANALYTICS[Analytics Service]
    end
    
    WEB --> LB
    MOBILE --> LB
    API_CLIENT --> LB
    
    LB --> API
    
    API --> AUTH
    API --> GOV
    API --> WALLET
    API --> USER
    
    AUTH --> DAO
    GOV --> VOTING
    WALLET --> TOKEN
    USER --> PROPOSAL
    
    DAO --> DB
    VOTING --> DB
    TOKEN --> DB
    PROPOSAL --> DB
    
    DAO --> CACHE
    VOTING --> CACHE
    TOKEN --> CACHE
    PROPOSAL --> CACHE
    
    DAO --> FILES
    VOTING --> FILES
    TOKEN --> FILES
    PROPOSAL --> FILES
    
    TOKEN --> ETH
    VOTING --> SMART_CONTRACTS
    
    API --> EMAIL
    API --> SMS
    API --> ANALYTICS
```

### Microservices Architecture
```mermaid
graph TB
    subgraph "API Gateway"
        GATEWAY[API Gateway]
        RATE_LIMIT[Rate Limiting]
        AUTH_MIDDLEWARE[Auth Middleware]
        LOGGING[Request Logging]
    end
    
    subgraph "Core Services"
        USER_SVC[User Service]
        AUTH_SVC[Auth Service]
        PROFILE_SVC[Profile Service]
        NOTIFICATION_SVC[Notification Service]
    end
    
    subgraph "DAO Services"
        PROPOSAL_SVC[Proposal Service]
        VOTING_SVC[Voting Service]
        GOVERNANCE_SVC[Governance Service]
        TREASURY_SVC[Treasury Service]
    end
    
    subgraph "Blockchain Services"
        WALLET_SVC[Wallet Service]
        TOKEN_SVC[Token Service]
        CONTRACT_SVC[Contract Service]
        TRANSACTION_SVC[Transaction Service]
    end
    
    subgraph "Support Services"
        FILE_SVC[File Service]
        EMAIL_SVC[Email Service]
        SMS_SVC[SMS Service]
        ANALYTICS_SVC[Analytics Service]
    end
    
    subgraph "Data Services"
        DB_SVC[Database Service]
        CACHE_SVC[Cache Service]
        SEARCH_SVC[Search Service]
        QUEUE_SVC[Queue Service]
    end
    
    GATEWAY --> USER_SVC
    GATEWAY --> AUTH_SVC
    GATEWAY --> PROFILE_SVC
    GATEWAY --> NOTIFICATION_SVC
    
    GATEWAY --> PROPOSAL_SVC
    GATEWAY --> VOTING_SVC
    GATEWAY --> GOVERNANCE_SVC
    GATEWAY --> TREASURY_SVC
    
    GATEWAY --> WALLET_SVC
    GATEWAY --> TOKEN_SVC
    GATEWAY --> CONTRACT_SVC
    GATEWAY --> TRANSACTION_SVC
    
    GATEWAY --> FILE_SVC
    GATEWAY --> EMAIL_SVC
    GATEWAY --> SMS_SVC
    GATEWAY --> ANALYTICS_SVC
    
    USER_SVC --> DB_SVC
    AUTH_SVC --> DB_SVC
    PROFILE_SVC --> DB_SVC
    NOTIFICATION_SVC --> DB_SVC
    
    PROPOSAL_SVC --> DB_SVC
    VOTING_SVC --> DB_SVC
    GOVERNANCE_SVC --> DB_SVC
    TREASURY_SVC --> DB_SVC
    
    WALLET_SVC --> DB_SVC
    TOKEN_SVC --> DB_SVC
    CONTRACT_SVC --> DB_SVC
    TRANSACTION_SVC --> DB_SVC
    
    FILE_SVC --> DB_SVC
    EMAIL_SVC --> DB_SVC
    SMS_SVC --> DB_SVC
    ANALYTICS_SVC --> DB_SVC
    
    USER_SVC --> CACHE_SVC
    AUTH_SVC --> CACHE_SVC
    PROFILE_SVC --> CACHE_SVC
    NOTIFICATION_SVC --> CACHE_SVC
    
    PROPOSAL_SVC --> CACHE_SVC
    VOTING_SVC --> CACHE_SVC
    GOVERNANCE_SVC --> CACHE_SVC
    TREASURY_SVC --> CACHE_SVC
    
    WALLET_SVC --> CACHE_SVC
    TOKEN_SVC --> CACHE_SVC
    CONTRACT_SVC --> CACHE_SVC
    TRANSACTION_SVC --> CACHE_SVC
    
    FILE_SVC --> CACHE_SVC
    EMAIL_SVC --> CACHE_SVC
    SMS_SVC --> CACHE_SVC
    ANALYTICS_SVC --> CACHE_SVC
```

## Component Architecture

### User Management Component
```mermaid
graph TB
    subgraph "User Management"
        USER_API[User API]
        USER_SERVICE[User Service]
        PROFILE_SERVICE[Profile Service]
        AUTH_SERVICE[Auth Service]
    end
    
    subgraph "Data Layer"
        USER_DB[(User Database)]
        PROFILE_DB[(Profile Database)]
        AUTH_DB[(Auth Database)]
        SESSION_CACHE[(Session Cache)]
    end
    
    subgraph "External Services"
        EMAIL_SERVICE[Email Service]
        SMS_SERVICE[SMS Service]
        OAuth_PROVIDER[OAuth Provider]
    end
    
    USER_API --> USER_SERVICE
    USER_API --> PROFILE_SERVICE
    USER_API --> AUTH_SERVICE
    
    USER_SERVICE --> USER_DB
    PROFILE_SERVICE --> PROFILE_DB
    AUTH_SERVICE --> AUTH_DB
    
    AUTH_SERVICE --> SESSION_CACHE
    
    USER_SERVICE --> EMAIL_SERVICE
    AUTH_SERVICE --> SMS_SERVICE
    AUTH_SERVICE --> OAuth_PROVIDER
```

### Governance Component
```mermaid
graph TB
    subgraph "Governance Management"
        GOV_API[Governance API]
        PROPOSAL_SERVICE[Proposal Service]
        VOTING_SERVICE[Voting Service]
        TREASURY_SERVICE[Treasury Service]
    end
    
    subgraph "Data Layer"
        PROPOSAL_DB[(Proposal Database)]
        VOTING_DB[(Voting Database)]
        TREASURY_DB[(Treasury Database)]
        VOTE_CACHE[(Vote Cache)]
    end
    
    subgraph "Blockchain Layer"
        SMART_CONTRACTS[Smart Contracts]
        BLOCKCHAIN_NETWORK[Blockchain Network]
    end
    
    subgraph "External Services"
        NOTIFICATION_SERVICE[Notification Service]
        ANALYTICS_SERVICE[Analytics Service]
    end
    
    GOV_API --> PROPOSAL_SERVICE
    GOV_API --> VOTING_SERVICE
    GOV_API --> TREASURY_SERVICE
    
    PROPOSAL_SERVICE --> PROPOSAL_DB
    VOTING_SERVICE --> VOTING_DB
    TREASURY_SERVICE --> TREASURY_DB
    
    VOTING_SERVICE --> VOTE_CACHE
    
    PROPOSAL_SERVICE --> SMART_CONTRACTS
    VOTING_SERVICE --> SMART_CONTRACTS
    TREASURY_SERVICE --> SMART_CONTRACTS
    
    SMART_CONTRACTS --> BLOCKCHAIN_NETWORK
    
    PROPOSAL_SERVICE --> NOTIFICATION_SERVICE
    VOTING_SERVICE --> NOTIFICATION_SERVICE
    TREASURY_SERVICE --> NOTIFICATION_SERVICE
    
    PROPOSAL_SERVICE --> ANALYTICS_SERVICE
    VOTING_SERVICE --> ANALYTICS_SERVICE
    TREASURY_SERVICE --> ANALYTICS_SERVICE
```

### Wallet Component
```mermaid
graph TB
    subgraph "Wallet Management"
        WALLET_API[Wallet API]
        WALLET_SERVICE[Wallet Service]
        TOKEN_SERVICE[Token Service]
        TRANSACTION_SERVICE[Transaction Service]
    end
    
    subgraph "Data Layer"
        WALLET_DB[(Wallet Database)]
        TOKEN_DB[(Token Database)]
        TRANSACTION_DB[(Transaction Database)]
        BALANCE_CACHE[(Balance Cache)]
    end
    
    subgraph "Blockchain Layer"
        ETHEREUM[Ethereum Network]
        SMART_CONTRACTS[Smart Contracts]
        WEB3[Web3 Provider]
    end
    
    subgraph "External Services"
        PRICE_FEED[Price Feed Service]
        GAS_ESTIMATOR[Gas Estimator]
        BLOCK_EXPLORER[Block Explorer]
    end
    
    WALLET_API --> WALLET_SERVICE
    WALLET_API --> TOKEN_SERVICE
    WALLET_API --> TRANSACTION_SERVICE
    
    WALLET_SERVICE --> WALLET_DB
    TOKEN_SERVICE --> TOKEN_DB
    TRANSACTION_SERVICE --> TRANSACTION_DB
    
    WALLET_SERVICE --> BALANCE_CACHE
    TOKEN_SERVICE --> BALANCE_CACHE
    TRANSACTION_SERVICE --> BALANCE_CACHE
    
    WALLET_SERVICE --> ETHEREUM
    TOKEN_SERVICE --> ETHEREUM
    TRANSACTION_SERVICE --> ETHEREUM
    
    WALLET_SERVICE --> SMART_CONTRACTS
    TOKEN_SERVICE --> SMART_CONTRACTS
    TRANSACTION_SERVICE --> SMART_CONTRACTS
    
    SMART_CONTRACTS --> WEB3
    
    TOKEN_SERVICE --> PRICE_FEED
    TRANSACTION_SERVICE --> GAS_ESTIMATOR
    TRANSACTION_SERVICE --> BLOCK_EXPLORER
```

## Data Flow Diagrams

### User Registration Flow
```mermaid
sequenceDiagram
    participant U as User
    participant W as Web App
    participant A as API Gateway
    participant US as User Service
    participant AS as Auth Service
    participant DB as Database
    participant E as Email Service
    
    U->>W: Fill registration form
    W->>A: POST /auth/register
    A->>US: Validate user data
    US->>DB: Check if user exists
    DB-->>US: User not found
    US->>AS: Create user account
    AS->>DB: Store user data
    AS->>E: Send verification email
    E-->>U: Verification email
    U->>E: Click verification link
    E->>AS: Verify email
    AS->>DB: Update user status
    AS-->>A: Registration successful
    A-->>W: Success response
    W-->>U: Registration complete
```

### Proposal Creation Flow
```mermaid
sequenceDiagram
    participant U as User
    participant W as Web App
    participant A as API Gateway
    participant PS as Proposal Service
    participant VS as Voting Service
    participant DB as Database
    participant SC as Smart Contract
    participant N as Notification Service
    
    U->>W: Create proposal
    W->>A: POST /proposals
    A->>PS: Validate proposal data
    PS->>DB: Store proposal
    PS->>VS: Initialize voting
    VS->>SC: Deploy voting contract
    SC-->>VS: Contract address
    VS->>DB: Store contract info
    PS->>N: Send proposal notification
    N-->>U: Proposal created
    PS-->>A: Proposal created
    A-->>W: Success response
    W-->>U: Proposal published
```

### Voting Flow
```mermaid
sequenceDiagram
    participant U as User
    participant W as Web App
    participant A as API Gateway
    participant VS as Voting Service
    participant WS as Wallet Service
    participant SC as Smart Contract
    participant DB as Database
    participant N as Notification Service
    
    U->>W: Cast vote
    W->>A: POST /proposals/{id}/vote
    A->>VS: Validate vote
    VS->>WS: Check user balance
    WS-->>VS: Balance confirmed
    VS->>SC: Submit vote
    SC-->>VS: Vote recorded
    VS->>DB: Store vote
    VS->>N: Send vote confirmation
    N-->>U: Vote confirmed
    VS-->>A: Vote successful
    A-->>W: Success response
    W-->>U: Vote cast
```

## Deployment Architecture

### Production Deployment
```mermaid
graph TB
    subgraph "CDN Layer"
        CDN[Content Delivery Network]
    end
    
    subgraph "Load Balancer Layer"
        LB[Load Balancer]
        SSL[SSL Termination]
    end
    
    subgraph "Application Layer"
        API1[API Server 1]
        API2[API Server 2]
        API3[API Server 3]
    end
    
    subgraph "Database Layer"
        DB_MASTER[(Master Database)]
        DB_SLAVE1[(Slave Database 1)]
        DB_SLAVE2[(Slave Database 2)]
    end
    
    subgraph "Cache Layer"
        REDIS1[(Redis Cluster 1)]
        REDIS2[(Redis Cluster 2)]
    end
    
    subgraph "Storage Layer"
        S3[(S3 Storage)]
        BACKUP[(Backup Storage)]
    end
    
    subgraph "Monitoring Layer"
        PROMETHEUS[Prometheus]
        GRAFANA[Grafana]
        ALERTMANAGER[AlertManager]
    end
    
    CDN --> LB
    LB --> SSL
    SSL --> API1
    SSL --> API2
    SSL --> API3
    
    API1 --> DB_MASTER
    API2 --> DB_MASTER
    API3 --> DB_MASTER
    
    API1 --> DB_SLAVE1
    API2 --> DB_SLAVE2
    API3 --> DB_SLAVE1
    
    API1 --> REDIS1
    API2 --> REDIS2
    API3 --> REDIS1
    
    API1 --> S3
    API2 --> S3
    API3 --> S3
    
    DB_MASTER --> BACKUP
    DB_SLAVE1 --> BACKUP
    DB_SLAVE2 --> BACKUP
    
    API1 --> PROMETHEUS
    API2 --> PROMETHEUS
    API3 --> PROMETHEUS
    
    PROMETHEUS --> GRAFANA
    PROMETHEUS --> ALERTMANAGER
```

### Kubernetes Deployment
```mermaid
graph TB
    subgraph "Kubernetes Cluster"
        subgraph "Ingress Layer"
            INGRESS[Ingress Controller]
            NGINX[Nginx Ingress]
        end
        
        subgraph "Application Layer"
            API_POD1[API Pod 1]
            API_POD2[API Pod 2]
            API_POD3[API Pod 3]
        end
        
        subgraph "Service Layer"
            API_SVC[API Service]
            DB_SVC[Database Service]
            REDIS_SVC[Redis Service]
        end
        
        subgraph "Storage Layer"
            PV1[Persistent Volume 1]
            PV2[Persistent Volume 2]
            PV3[Persistent Volume 3]
        end
        
        subgraph "Monitoring Layer"
            PROMETHEUS_POD[Prometheus Pod]
            GRAFANA_POD[Grafana Pod]
            ALERTMANAGER_POD[AlertManager Pod]
        end
    end
    
    subgraph "External Services"
        EXTERNAL_DB[(External Database)]
        EXTERNAL_REDIS[(External Redis)]
        EXTERNAL_S3[(External S3)]
    end
    
    INGRESS --> NGINX
    NGINX --> API_SVC
    API_SVC --> API_POD1
    API_SVC --> API_POD2
    API_SVC --> API_POD3
    
    API_POD1 --> DB_SVC
    API_POD2 --> DB_SVC
    API_POD3 --> DB_SVC
    
    API_POD1 --> REDIS_SVC
    API_POD2 --> REDIS_SVC
    API_POD3 --> REDIS_SVC
    
    DB_SVC --> EXTERNAL_DB
    REDIS_SVC --> EXTERNAL_REDIS
    
    API_POD1 --> PV1
    API_POD2 --> PV2
    API_POD3 --> PV3
    
    API_POD1 --> PROMETHEUS_POD
    API_POD2 --> PROMETHEUS_POD
    API_POD3 --> PROMETHEUS_POD
    
    PROMETHEUS_POD --> GRAFANA_POD
    PROMETHEUS_POD --> ALERTMANAGER_POD
```

## Security Architecture

### Security Layers
```mermaid
graph TB
    subgraph "External Security"
        WAF[Web Application Firewall]
        DDoS[DDoS Protection]
        CDN_SEC[CDN Security]
    end
    
    subgraph "Network Security"
        FW[Firewall]
        VPN[VPN Gateway]
        IDS[Intrusion Detection]
    end
    
    subgraph "Application Security"
        AUTH[Authentication]
        AUTHZ[Authorization]
        ENCRYPTION[Data Encryption]
        AUDIT[Audit Logging]
    end
    
    subgraph "Data Security"
        DB_ENCRYPTION[Database Encryption]
        BACKUP_ENCRYPTION[Backup Encryption]
        KEY_MANAGEMENT[Key Management]
    end
    
    subgraph "Infrastructure Security"
        OS_SEC[OS Hardening]
        CONTAINER_SEC[Container Security]
        RUNTIME_SEC[Runtime Security]
    end
    
    WAF --> FW
    DDoS --> FW
    CDN_SEC --> FW
    
    FW --> VPN
    FW --> IDS
    
    VPN --> AUTH
    IDS --> AUTH
    
    AUTH --> AUTHZ
    AUTHZ --> ENCRYPTION
    ENCRYPTION --> AUDIT
    
    AUDIT --> DB_ENCRYPTION
    DB_ENCRYPTION --> BACKUP_ENCRYPTION
    BACKUP_ENCRYPTION --> KEY_MANAGEMENT
    
    KEY_MANAGEMENT --> OS_SEC
    OS_SEC --> CONTAINER_SEC
    CONTAINER_SEC --> RUNTIME_SEC
```

### Authentication Flow
```mermaid
sequenceDiagram
    participant U as User
    participant W as Web App
    participant A as API Gateway
    participant AS as Auth Service
    participant DB as Database
    participant C as Cache
    participant SC as Smart Contract
    
    U->>W: Login request
    W->>A: POST /auth/login
    A->>AS: Validate credentials
    AS->>DB: Check user data
    DB-->>AS: User found
    AS->>C: Store session
    AS->>SC: Verify wallet signature
    SC-->>AS: Signature valid
    AS-->>A: JWT token
    A-->>W: Authentication success
    W-->>U: Login successful
```

## Network Architecture

### Network Topology
```mermaid
graph TB
    subgraph "Internet"
        INTERNET[Internet]
    end
    
    subgraph "DMZ"
        WAF[Web Application Firewall]
        LB[Load Balancer]
        DNS[DNS Server]
    end
    
    subgraph "Application Tier"
        API1[API Server 1]
        API2[API Server 2]
        API3[API Server 3]
    end
    
    subgraph "Database Tier"
        DB_MASTER[(Master DB)]
        DB_SLAVE1[(Slave DB 1)]
        DB_SLAVE2[(Slave DB 2)]
    end
    
    subgraph "Cache Tier"
        REDIS1[(Redis 1)]
        REDIS2[(Redis 2)]
    end
    
    subgraph "Storage Tier"
        NFS[NFS Server]
        BACKUP[Backup Server]
    end
    
    subgraph "Management Tier"
        MONITOR[Monitoring Server]
        LOG[Log Server]
        ADMIN[Admin Server]
    end
    
    INTERNET --> WAF
    WAF --> LB
    LB --> DNS
    
    LB --> API1
    LB --> API2
    LB --> API3
    
    API1 --> DB_MASTER
    API2 --> DB_MASTER
    API3 --> DB_MASTER
    
    API1 --> DB_SLAVE1
    API2 --> DB_SLAVE2
    API3 --> DB_SLAVE1
    
    API1 --> REDIS1
    API2 --> REDIS2
    API3 --> REDIS1
    
    API1 --> NFS
    API2 --> NFS
    API3 --> NFS
    
    DB_MASTER --> BACKUP
    DB_SLAVE1 --> BACKUP
    DB_SLAVE2 --> BACKUP
    
    API1 --> MONITOR
    API2 --> MONITOR
    API3 --> MONITOR
    
    API1 --> LOG
    API2 --> LOG
    API3 --> LOG
    
    ADMIN --> API1
    ADMIN --> API2
    ADMIN --> API3
    ADMIN --> DB_MASTER
    ADMIN --> REDIS1
    ADMIN --> REDIS2
```

## Conclusion

These system architecture diagrams provide comprehensive visual representations of the REChain DAO platform's architecture, including component interactions, data flows, deployment strategies, and security measures. They serve as essential documentation for developers, architects, and stakeholders to understand the system's design and implementation.

Remember: Architecture diagrams should be regularly updated to reflect changes in the system. They are living documents that evolve with the platform and should be maintained alongside the codebase.
