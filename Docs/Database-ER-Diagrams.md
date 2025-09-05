# Database ER Diagrams

## Overview

This document provides comprehensive Entity-Relationship (ER) diagrams for the REChain DAO platform database, including all entities, relationships, and constraints.

## Table of Contents

1. [Core Entities](#core-entities)
2. [User Management](#user-management)
3. [Governance System](#governance-system)
4. [Wallet System](#wallet-system)
5. [Token Management](#token-management)
6. [Transaction System](#transaction-system)
7. [Notification System](#notification-system)
8. [Audit and Logging](#audit-and-logging)

## Core Entities

### Main ER Diagram
```mermaid
erDiagram
    USERS ||--o{ USER_PROFILES : has
    USERS ||--o{ USER_WALLETS : owns
    USERS ||--o{ USER_SESSIONS : creates
    USERS ||--o{ USER_ROLES : assigned
    
    USER_PROFILES ||--o{ USER_PREFERENCES : has
    USER_PROFILES ||--o{ USER_ACTIVITY : tracks
    
    USER_WALLETS ||--o{ WALLET_TRANSACTIONS : contains
    USER_WALLETS ||--o{ WALLET_TOKENS : holds
    
    PROPOSALS ||--o{ PROPOSAL_VOTES : receives
    PROPOSALS ||--o{ PROPOSAL_COMMENTS : has
    PROPOSALS ||--o{ PROPOSAL_ATTACHMENTS : includes
    
    PROPOSAL_VOTES }o--|| USERS : cast_by
    PROPOSAL_VOTES }o--|| PROPOSALS : for_proposal
    
    TOKENS ||--o{ WALLET_TOKENS : held_in
    TOKENS ||--o{ TOKEN_TRANSACTIONS : involved_in
    
    WALLET_TRANSACTIONS }o--|| USER_WALLETS : from_wallet
    WALLET_TRANSACTIONS }o--|| USER_WALLETS : to_wallet
    WALLET_TRANSACTIONS }o--|| TOKENS : token_type
    
    NOTIFICATIONS }o--|| USERS : sent_to
    NOTIFICATIONS ||--o{ NOTIFICATION_READS : tracked_by
    
    AUDIT_LOGS }o--|| USERS : performed_by
    AUDIT_LOGS ||--o{ AUDIT_DETAILS : contains
```

## User Management

### User Entities
```mermaid
erDiagram
    USERS {
        uuid id PK
        string username UK
        string email UK
        string password_hash
        string first_name
        string last_name
        string avatar_url
        string bio
        string location
        string website
        boolean is_verified
        boolean is_active
        boolean is_banned
        timestamp created_at
        timestamp updated_at
        timestamp last_login
        string verification_token
        timestamp verification_expires
        string reset_token
        timestamp reset_expires
    }
    
    USER_PROFILES {
        uuid id PK
        uuid user_id FK
        json preferences
        json social_links
        json privacy_settings
        string timezone
        string language
        timestamp created_at
        timestamp updated_at
    }
    
    USER_PREFERENCES {
        uuid id PK
        uuid profile_id FK
        string preference_key
        string preference_value
        timestamp created_at
        timestamp updated_at
    }
    
    USER_ROLES {
        uuid id PK
        uuid user_id FK
        string role_name
        string scope
        timestamp assigned_at
        timestamp expires_at
        boolean is_active
    }
    
    USER_SESSIONS {
        uuid id PK
        uuid user_id FK
        string session_token
        string ip_address
        string user_agent
        timestamp created_at
        timestamp expires_at
        boolean is_active
    }
    
    USER_ACTIVITY {
        uuid id PK
        uuid user_id FK
        string activity_type
        string description
        json metadata
        timestamp created_at
    }
    
    USERS ||--o{ USER_PROFILES : has
    USERS ||--o{ USER_PREFERENCES : has
    USERS ||--o{ USER_ROLES : assigned
    USERS ||--o{ USER_SESSIONS : creates
    USERS ||--o{ USER_ACTIVITY : performs
    USER_PROFILES ||--o{ USER_PREFERENCES : contains
```

## Governance System

### Proposal and Voting Entities
```mermaid
erDiagram
    PROPOSALS {
        uuid id PK
        uuid proposer_id FK
        string title
        text description
        string status
        string category
        json tags
        json metadata
        timestamp created_at
        timestamp updated_at
        timestamp voting_start
        timestamp voting_end
        integer votes_for
        integer votes_against
        integer total_votes
        integer quorum_required
        boolean is_executed
        timestamp executed_at
        string execution_hash
    }
    
    PROPOSAL_VOTES {
        uuid id PK
        uuid proposal_id FK
        uuid voter_id FK
        string vote_type
        string reason
        json metadata
        timestamp created_at
        timestamp updated_at
    }
    
    PROPOSAL_COMMENTS {
        uuid id PK
        uuid proposal_id FK
        uuid user_id FK
        uuid parent_id FK
        text content
        integer likes
        integer dislikes
        boolean is_deleted
        timestamp created_at
        timestamp updated_at
    }
    
    PROPOSAL_ATTACHMENTS {
        uuid id PK
        uuid proposal_id FK
        string file_name
        string file_url
        string file_type
        integer file_size
        timestamp created_at
    }
    
    VOTING_POWER {
        uuid id PK
        uuid user_id FK
        uuid proposal_id FK
        decimal power_amount
        string power_source
        timestamp calculated_at
    }
    
    PROPOSALS ||--o{ PROPOSAL_VOTES : receives
    PROPOSALS ||--o{ PROPOSAL_COMMENTS : has
    PROPOSALS ||--o{ PROPOSAL_ATTACHMENTS : includes
    PROPOSALS ||--o{ VOTING_POWER : calculates
    PROPOSAL_VOTES }o--|| USERS : cast_by
    PROPOSAL_COMMENTS }o--|| USERS : written_by
    PROPOSAL_COMMENTS ||--o{ PROPOSAL_COMMENTS : replies_to
    VOTING_POWER }o--|| USERS : belongs_to
```

## Wallet System

### Wallet and Transaction Entities
```mermaid
erDiagram
    USER_WALLETS {
        uuid id PK
        uuid user_id FK
        string address
        string network
        string wallet_type
        json metadata
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }
    
    WALLET_TRANSACTIONS {
        uuid id PK
        uuid from_wallet_id FK
        uuid to_wallet_id FK
        uuid token_id FK
        string transaction_hash
        decimal amount
        decimal gas_used
        decimal gas_price
        string status
        integer block_number
        timestamp created_at
        timestamp confirmed_at
    }
    
    WALLET_TOKENS {
        uuid id PK
        uuid wallet_id FK
        uuid token_id FK
        decimal balance
        decimal locked_balance
        timestamp last_updated
    }
    
    WALLET_ADDRESSES {
        uuid id PK
        uuid wallet_id FK
        string address
        string address_type
        boolean is_primary
        timestamp created_at
    }
    
    TRANSACTION_RECEIPTS {
        uuid id PK
        uuid transaction_id FK
        string receipt_hash
        integer gas_used
        string status
        json logs
        timestamp created_at
    }
    
    USER_WALLETS ||--o{ WALLET_TRANSACTIONS : sends
    USER_WALLETS ||--o{ WALLET_TRANSACTIONS : receives
    USER_WALLETS ||--o{ WALLET_TOKENS : holds
    USER_WALLETS ||--o{ WALLET_ADDRESSES : contains
    WALLET_TRANSACTIONS ||--o{ TRANSACTION_RECEIPTS : has
    WALLET_TOKENS }o--|| TOKENS : token_type
```

## Token Management

### Token and Balance Entities
```mermaid
erDiagram
    TOKENS {
        uuid id PK
        string symbol
        string name
        string contract_address
        string network
        integer decimals
        decimal total_supply
        decimal circulating_supply
        string token_type
        json metadata
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }
    
    TOKEN_BALANCES {
        uuid id PK
        uuid user_id FK
        uuid token_id FK
        decimal balance
        decimal locked_balance
        decimal staked_balance
        timestamp last_updated
    }
    
    TOKEN_TRANSFERS {
        uuid id PK
        uuid from_user_id FK
        uuid to_user_id FK
        uuid token_id FK
        decimal amount
        string transfer_type
        json metadata
        timestamp created_at
    }
    
    TOKEN_STAKING {
        uuid id PK
        uuid user_id FK
        uuid token_id FK
        decimal staked_amount
        decimal rewards_earned
        timestamp staked_at
        timestamp unstaked_at
        boolean is_active
    }
    
    TOKEN_PRICES {
        uuid id PK
        uuid token_id FK
        decimal price_usd
        decimal price_btc
        decimal price_eth
        decimal market_cap
        decimal volume_24h
        timestamp updated_at
    }
    
    TOKENS ||--o{ TOKEN_BALANCES : held_by
    TOKENS ||--o{ TOKEN_TRANSFERS : involved_in
    TOKENS ||--o{ TOKEN_STAKING : staked
    TOKENS ||--o{ TOKEN_PRICES : priced
    TOKEN_BALANCES }o--|| USERS : belongs_to
    TOKEN_TRANSFERS }o--|| USERS : from_user
    TOKEN_TRANSFERS }o--|| USERS : to_user
    TOKEN_STAKING }o--|| USERS : staked_by
```

## Transaction System

### Transaction and Block Entities
```mermaid
erDiagram
    BLOCKCHAIN_TRANSACTIONS {
        uuid id PK
        string transaction_hash UK
        string block_hash
        integer block_number
        string from_address
        string to_address
        decimal value
        decimal gas_used
        decimal gas_price
        string status
        json logs
        timestamp created_at
        timestamp confirmed_at
    }
    
    TRANSACTION_LOGS {
        uuid id PK
        uuid transaction_id FK
        string log_index
        string address
        json topics
        text data
        timestamp created_at
    }
    
    BLOCKCHAIN_BLOCKS {
        uuid id PK
        string block_hash UK
        integer block_number UK
        string parent_hash
        string miner
        decimal difficulty
        decimal total_difficulty
        integer gas_limit
        integer gas_used
        timestamp timestamp
        json extra_data
    }
    
    SMART_CONTRACTS {
        uuid id PK
        string contract_address UK
        string contract_name
        string abi
        string bytecode
        string network
        boolean is_verified
        timestamp deployed_at
        timestamp updated_at
    }
    
    CONTRACT_EVENTS {
        uuid id PK
        uuid contract_id FK
        string event_name
        json event_data
        string transaction_hash
        integer log_index
        timestamp created_at
    }
    
    BLOCKCHAIN_TRANSACTIONS ||--o{ TRANSACTION_LOGS : has
    BLOCKCHAIN_TRANSACTIONS }o--|| BLOCKCHAIN_BLOCKS : in_block
    SMART_CONTRACTS ||--o{ CONTRACT_EVENTS : emits
    CONTRACT_EVENTS }o--|| BLOCKCHAIN_TRANSACTIONS : from_transaction
```

## Notification System

### Notification and Communication Entities
```mermaid
erDiagram
    NOTIFICATIONS {
        uuid id PK
        uuid user_id FK
        string notification_type
        string title
        text content
        json metadata
        boolean is_read
        timestamp created_at
        timestamp read_at
    }
    
    NOTIFICATION_TEMPLATES {
        uuid id PK
        string template_name
        string notification_type
        text subject_template
        text body_template
        json variables
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }
    
    NOTIFICATION_CHANNELS {
        uuid id PK
        string channel_name
        string channel_type
        json configuration
        boolean is_active
        timestamp created_at
        timestamp updated_at
    }
    
    NOTIFICATION_DELIVERIES {
        uuid id PK
        uuid notification_id FK
        uuid channel_id FK
        string status
        string error_message
        timestamp sent_at
        timestamp delivered_at
    }
    
    USER_NOTIFICATION_PREFERENCES {
        uuid id PK
        uuid user_id FK
        string notification_type
        boolean email_enabled
        boolean sms_enabled
        boolean push_enabled
        boolean in_app_enabled
        timestamp created_at
        timestamp updated_at
    }
    
    NOTIFICATIONS }o--|| USERS : sent_to
    NOTIFICATIONS ||--o{ NOTIFICATION_DELIVERIES : delivered_via
    NOTIFICATION_TEMPLATES ||--o{ NOTIFICATIONS : used_for
    NOTIFICATION_CHANNELS ||--o{ NOTIFICATION_DELIVERIES : via_channel
    USER_NOTIFICATION_PREFERENCES }o--|| USERS : belongs_to
```

## Audit and Logging

### Audit and Log Entities
```mermaid
erDiagram
    AUDIT_LOGS {
        uuid id PK
        uuid user_id FK
        string action
        string resource_type
        uuid resource_id
        json old_values
        json new_values
        string ip_address
        string user_agent
        timestamp created_at
    }
    
    AUDIT_DETAILS {
        uuid id PK
        uuid audit_log_id FK
        string field_name
        string old_value
        string new_value
        timestamp created_at
    }
    
    SYSTEM_LOGS {
        uuid id PK
        string log_level
        string logger_name
        text message
        json context
        string thread_name
        timestamp created_at
    }
    
    ERROR_LOGS {
        uuid id PK
        string error_type
        text error_message
        text stack_trace
        json context
        uuid user_id FK
        string ip_address
        timestamp created_at
    }
    
    SECURITY_LOGS {
        uuid id PK
        string event_type
        string severity
        text description
        json metadata
        string ip_address
        string user_agent
        timestamp created_at
    }
    
    AUDIT_LOGS ||--o{ AUDIT_DETAILS : contains
    AUDIT_LOGS }o--|| USERS : performed_by
    ERROR_LOGS }o--|| USERS : experienced_by
    SECURITY_LOGS }o--|| USERS : related_to
```

## Database Constraints and Indexes

### Primary Keys and Foreign Keys
```sql
-- Primary Keys
ALTER TABLE users ADD CONSTRAINT pk_users PRIMARY KEY (id);
ALTER TABLE user_profiles ADD CONSTRAINT pk_user_profiles PRIMARY KEY (id);
ALTER TABLE proposals ADD CONSTRAINT pk_proposals PRIMARY KEY (id);
ALTER TABLE proposal_votes ADD CONSTRAINT pk_proposal_votes PRIMARY KEY (id);
ALTER TABLE user_wallets ADD CONSTRAINT pk_user_wallets PRIMARY KEY (id);
ALTER TABLE wallet_transactions ADD CONSTRAINT pk_wallet_transactions PRIMARY KEY (id);
ALTER TABLE tokens ADD CONSTRAINT pk_tokens PRIMARY KEY (id);
ALTER TABLE notifications ADD CONSTRAINT pk_notifications PRIMARY KEY (id);
ALTER TABLE audit_logs ADD CONSTRAINT pk_audit_logs PRIMARY KEY (id);

-- Foreign Keys
ALTER TABLE user_profiles ADD CONSTRAINT fk_user_profiles_user_id 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE proposal_votes ADD CONSTRAINT fk_proposal_votes_proposal_id 
    FOREIGN KEY (proposal_id) REFERENCES proposals(id) ON DELETE CASCADE;

ALTER TABLE proposal_votes ADD CONSTRAINT fk_proposal_votes_user_id 
    FOREIGN KEY (voter_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE user_wallets ADD CONSTRAINT fk_user_wallets_user_id 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE wallet_transactions ADD CONSTRAINT fk_wallet_transactions_from_wallet 
    FOREIGN KEY (from_wallet_id) REFERENCES user_wallets(id) ON DELETE CASCADE;

ALTER TABLE wallet_transactions ADD CONSTRAINT fk_wallet_transactions_to_wallet 
    FOREIGN KEY (to_wallet_id) REFERENCES user_wallets(id) ON DELETE CASCADE;

ALTER TABLE notifications ADD CONSTRAINT fk_notifications_user_id 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

ALTER TABLE audit_logs ADD CONSTRAINT fk_audit_logs_user_id 
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;
```

### Indexes for Performance
```sql
-- User indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_created_at ON users(created_at);
CREATE INDEX idx_users_is_active ON users(is_active);

-- Proposal indexes
CREATE INDEX idx_proposals_status ON proposals(status);
CREATE INDEX idx_proposals_created_at ON proposals(created_at);
CREATE INDEX idx_proposals_voting_start ON proposals(voting_start);
CREATE INDEX idx_proposals_voting_end ON proposals(voting_end);
CREATE INDEX idx_proposals_proposer_id ON proposals(proposer_id);

-- Vote indexes
CREATE INDEX idx_proposal_votes_proposal_id ON proposal_votes(proposal_id);
CREATE INDEX idx_proposal_votes_voter_id ON proposal_votes(voter_id);
CREATE INDEX idx_proposal_votes_created_at ON proposal_votes(created_at);

-- Wallet indexes
CREATE INDEX idx_user_wallets_user_id ON user_wallets(user_id);
CREATE INDEX idx_user_wallets_address ON user_wallets(address);
CREATE INDEX idx_user_wallets_network ON user_wallets(network);

-- Transaction indexes
CREATE INDEX idx_wallet_transactions_from_wallet ON wallet_transactions(from_wallet_id);
CREATE INDEX idx_wallet_transactions_to_wallet ON wallet_transactions(to_wallet_id);
CREATE INDEX idx_wallet_transactions_created_at ON wallet_transactions(created_at);
CREATE INDEX idx_wallet_transactions_status ON wallet_transactions(status);

-- Token indexes
CREATE INDEX idx_tokens_symbol ON tokens(symbol);
CREATE INDEX idx_tokens_contract_address ON tokens(contract_address);
CREATE INDEX idx_tokens_network ON tokens(network);

-- Notification indexes
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_created_at ON notifications(created_at);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);

-- Audit log indexes
CREATE INDEX idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX idx_audit_logs_action ON audit_logs(action);
CREATE INDEX idx_audit_logs_created_at ON audit_logs(created_at);
CREATE INDEX idx_audit_logs_resource_type ON audit_logs(resource_type);
```

## Data Types and Constraints

### Custom Data Types
```sql
-- Enum types
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'banned', 'suspended');
CREATE TYPE proposal_status AS ENUM ('draft', 'active', 'passed', 'rejected', 'expired');
CREATE TYPE vote_type AS ENUM ('for', 'against', 'abstain');
CREATE TYPE transaction_status AS ENUM ('pending', 'confirmed', 'failed', 'cancelled');
CREATE TYPE notification_type AS ENUM ('info', 'warning', 'error', 'success');
CREATE TYPE log_level AS ENUM ('debug', 'info', 'warn', 'error', 'fatal');

-- Custom types
CREATE TYPE address_type AS (
    street VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    postal_code VARCHAR(20)
);

CREATE TYPE contact_info AS (
    email VARCHAR(255),
    phone VARCHAR(20),
    website VARCHAR(255)
);
```

### Check Constraints
```sql
-- User constraints
ALTER TABLE users ADD CONSTRAINT chk_users_email_format 
    CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');

ALTER TABLE users ADD CONSTRAINT chk_users_username_length 
    CHECK (char_length(username) >= 3 AND char_length(username) <= 50);

-- Proposal constraints
ALTER TABLE proposals ADD CONSTRAINT chk_proposals_voting_duration 
    CHECK (voting_end > voting_start);

ALTER TABLE proposals ADD CONSTRAINT chk_proposals_votes_positive 
    CHECK (votes_for >= 0 AND votes_against >= 0);

-- Transaction constraints
ALTER TABLE wallet_transactions ADD CONSTRAINT chk_wallet_transactions_amount_positive 
    CHECK (amount > 0);

ALTER TABLE wallet_transactions ADD CONSTRAINT chk_wallet_transactions_gas_positive 
    CHECK (gas_used >= 0 AND gas_price >= 0);

-- Token constraints
ALTER TABLE tokens ADD CONSTRAINT chk_tokens_decimals_range 
    CHECK (decimals >= 0 AND decimals <= 18);

ALTER TABLE tokens ADD CONSTRAINT chk_tokens_supply_positive 
    CHECK (total_supply >= 0 AND circulating_supply >= 0);
```

## Conclusion

These Entity-Relationship diagrams provide a comprehensive view of the REChain DAO platform's database structure, including all entities, relationships, constraints, and indexes. They serve as essential documentation for database design, development, and maintenance.

Remember: Database schemas should be versioned and migrated carefully. Always test schema changes in development environments before applying them to production databases.
