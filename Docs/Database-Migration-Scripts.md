# Database Migration Scripts

## Overview

This document provides comprehensive database migration scripts for the REChain DAO platform, including schema migrations, data migrations, and rollback procedures.

## Table of Contents

1. [Migration Framework](#migration-framework)
2. [Schema Migrations](#schema-migrations)
3. [Data Migrations](#data-migrations)
4. [Index Migrations](#index-migrations)
5. [Rollback Procedures](#rollback-procedures)
6. [Migration Tools](#migration-tools)

## Migration Framework

### Migration Structure
```sql
-- Migration: 001_initial_schema.sql
-- Description: Create initial database schema
-- Author: REChain DAO Team
-- Date: 2024-01-01
-- Version: 1.0.0

-- Up Migration
-- ===========

-- Create users table
CREATE TABLE IF NOT EXISTS users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uuid VARCHAR(36) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    avatar_url VARCHAR(500),
    bio TEXT,
    is_verified BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    
    INDEX idx_users_email (email),
    INDEX idx_users_username (username),
    INDEX idx_users_uuid (uuid),
    INDEX idx_users_created_at (created_at),
    INDEX idx_users_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create wallets table
CREATE TABLE IF NOT EXISTS wallets (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    address VARCHAR(42) NOT NULL UNIQUE,
    wallet_type ENUM('metamask', 'walletconnect', 'coinbase', 'ledger') NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    is_verified BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_wallets_user_id (user_id),
    INDEX idx_wallets_address (address),
    INDEX idx_wallets_type (wallet_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create proposals table
CREATE TABLE IF NOT EXISTS proposals (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uuid VARCHAR(36) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    proposer_id BIGINT UNSIGNED NOT NULL,
    proposal_type ENUM('governance', 'treasury', 'technical', 'social') NOT NULL,
    status ENUM('draft', 'active', 'passed', 'rejected', 'expired') DEFAULT 'draft',
    voting_start TIMESTAMP NULL,
    voting_end TIMESTAMP NULL,
    quorum_threshold DECIMAL(5,2) DEFAULT 20.00,
    approval_threshold DECIMAL(5,2) DEFAULT 50.00,
    total_votes BIGINT UNSIGNED DEFAULT 0,
    yes_votes BIGINT UNSIGNED DEFAULT 0,
    no_votes BIGINT UNSIGNED DEFAULT 0,
    abstain_votes BIGINT UNSIGNED DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (proposer_id) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_proposals_uuid (uuid),
    INDEX idx_proposals_proposer_id (proposer_id),
    INDEX idx_proposals_status (status),
    INDEX idx_proposals_type (proposal_type),
    INDEX idx_proposals_voting_start (voting_start),
    INDEX idx_proposals_voting_end (voting_end),
    INDEX idx_proposals_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create votes table
CREATE TABLE IF NOT EXISTS votes (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    proposal_id BIGINT UNSIGNED NOT NULL,
    voter_id BIGINT UNSIGNED NOT NULL,
    vote_type ENUM('yes', 'no', 'abstain') NOT NULL,
    voting_power DECIMAL(20,8) NOT NULL,
    reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (proposal_id) REFERENCES proposals(id) ON DELETE CASCADE,
    FOREIGN KEY (voter_id) REFERENCES users(id) ON DELETE CASCADE,
    UNIQUE KEY unique_vote (proposal_id, voter_id),
    INDEX idx_votes_proposal_id (proposal_id),
    INDEX idx_votes_voter_id (voter_id),
    INDEX idx_votes_type (vote_type),
    INDEX idx_votes_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create tokens table
CREATE TABLE IF NOT EXISTS tokens (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    symbol VARCHAR(10) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    contract_address VARCHAR(42) NOT NULL UNIQUE,
    decimals TINYINT UNSIGNED NOT NULL,
    total_supply DECIMAL(20,8) NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_tokens_symbol (symbol),
    INDEX idx_tokens_contract_address (contract_address),
    INDEX idx_tokens_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create user_tokens table
CREATE TABLE IF NOT EXISTS user_tokens (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    token_id BIGINT UNSIGNED NOT NULL,
    balance DECIMAL(20,8) NOT NULL DEFAULT 0,
    locked_balance DECIMAL(20,8) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (token_id) REFERENCES tokens(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_token (user_id, token_id),
    INDEX idx_user_tokens_user_id (user_id),
    INDEX idx_user_tokens_token_id (token_id),
    INDEX idx_user_tokens_balance (balance)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create transactions table
CREATE TABLE IF NOT EXISTS transactions (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    uuid VARCHAR(36) NOT NULL UNIQUE,
    user_id BIGINT UNSIGNED NOT NULL,
    transaction_type ENUM('deposit', 'withdrawal', 'transfer', 'vote', 'proposal') NOT NULL,
    token_id BIGINT UNSIGNED,
    amount DECIMAL(20,8),
    from_address VARCHAR(42),
    to_address VARCHAR(42),
    transaction_hash VARCHAR(66),
    status ENUM('pending', 'confirmed', 'failed', 'cancelled') DEFAULT 'pending',
    gas_used BIGINT UNSIGNED,
    gas_price DECIMAL(20,8),
    block_number BIGINT UNSIGNED,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (token_id) REFERENCES tokens(id) ON DELETE SET NULL,
    INDEX idx_transactions_uuid (uuid),
    INDEX idx_transactions_user_id (user_id),
    INDEX idx_transactions_type (transaction_type),
    INDEX idx_transactions_status (status),
    INDEX idx_transactions_hash (transaction_hash),
    INDEX idx_transactions_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create audit_logs table
CREATE TABLE IF NOT EXISTS audit_logs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED,
    action VARCHAR(100) NOT NULL,
    resource_type VARCHAR(50) NOT NULL,
    resource_id BIGINT UNSIGNED,
    old_values JSON,
    new_values JSON,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL,
    INDEX idx_audit_logs_user_id (user_id),
    INDEX idx_audit_logs_action (action),
    INDEX idx_audit_logs_resource_type (resource_type),
    INDEX idx_audit_logs_resource_id (resource_id),
    INDEX idx_audit_logs_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Down Migration
-- =============

-- Drop tables in reverse order
DROP TABLE IF EXISTS audit_logs;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS user_tokens;
DROP TABLE IF EXISTS tokens;
DROP TABLE IF EXISTS votes;
DROP TABLE IF EXISTS proposals;
DROP TABLE IF EXISTS wallets;
DROP TABLE IF EXISTS users;
```

## Schema Migrations

### Migration 002: Add Indexes
```sql
-- Migration: 002_add_indexes.sql
-- Description: Add performance indexes
-- Author: REChain DAO Team
-- Date: 2024-01-15
-- Version: 1.0.1

-- Up Migration
-- ===========

-- Add composite indexes for better query performance
ALTER TABLE users ADD INDEX idx_users_email_active (email, is_active);
ALTER TABLE users ADD INDEX idx_users_username_active (username, is_active);

ALTER TABLE proposals ADD INDEX idx_proposals_status_type (status, proposal_type);
ALTER TABLE proposals ADD INDEX idx_proposals_voting_period (voting_start, voting_end);

ALTER TABLE votes ADD INDEX idx_votes_proposal_voter (proposal_id, voter_id);
ALTER TABLE votes ADD INDEX idx_votes_proposal_type (proposal_id, vote_type);

ALTER TABLE transactions ADD INDEX idx_transactions_user_type (user_id, transaction_type);
ALTER TABLE transactions ADD INDEX idx_transactions_status_created (status, created_at);

ALTER TABLE user_tokens ADD INDEX idx_user_tokens_balance_desc (balance DESC);
ALTER TABLE user_tokens ADD INDEX idx_user_tokens_locked_balance (locked_balance);

-- Add full-text search indexes
ALTER TABLE proposals ADD FULLTEXT idx_proposals_title_description (title, description);
ALTER TABLE users ADD FULLTEXT idx_users_bio (bio);

-- Down Migration
-- =============

-- Remove composite indexes
ALTER TABLE users DROP INDEX idx_users_email_active;
ALTER TABLE users DROP INDEX idx_users_username_active;

ALTER TABLE proposals DROP INDEX idx_proposals_status_type;
ALTER TABLE proposals DROP INDEX idx_proposals_voting_period;

ALTER TABLE votes DROP INDEX idx_votes_proposal_voter;
ALTER TABLE votes DROP INDEX idx_votes_proposal_type;

ALTER TABLE transactions DROP INDEX idx_transactions_user_type;
ALTER TABLE transactions DROP INDEX idx_transactions_status_created;

ALTER TABLE user_tokens DROP INDEX idx_user_tokens_balance_desc;
ALTER TABLE user_tokens DROP INDEX idx_user_tokens_locked_balance;

-- Remove full-text search indexes
ALTER TABLE proposals DROP INDEX idx_proposals_title_description;
ALTER TABLE users DROP INDEX idx_users_bio;
```

### Migration 003: Add Notifications
```sql
-- Migration: 003_add_notifications.sql
-- Description: Add notification system
-- Author: REChain DAO Team
-- Date: 2024-02-01
-- Version: 1.0.2

-- Up Migration
-- ===========

-- Create notification_types table
CREATE TABLE IF NOT EXISTS notification_types (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    template TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    INDEX idx_notification_types_name (name),
    INDEX idx_notification_types_is_active (is_active)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create notifications table
CREATE TABLE IF NOT EXISTS notifications (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    notification_type_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    data JSON,
    is_read BOOLEAN DEFAULT FALSE,
    is_sent BOOLEAN DEFAULT FALSE,
    sent_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (notification_type_id) REFERENCES notification_types(id) ON DELETE CASCADE,
    INDEX idx_notifications_user_id (user_id),
    INDEX idx_notifications_type_id (notification_type_id),
    INDEX idx_notifications_is_read (is_read),
    INDEX idx_notifications_is_sent (is_sent),
    INDEX idx_notifications_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create user_notification_preferences table
CREATE TABLE IF NOT EXISTS user_notification_preferences (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    notification_type_id BIGINT UNSIGNED NOT NULL,
    email_enabled BOOLEAN DEFAULT TRUE,
    push_enabled BOOLEAN DEFAULT TRUE,
    sms_enabled BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (notification_type_id) REFERENCES notification_types(id) ON DELETE CASCADE,
    UNIQUE KEY unique_user_notification_preference (user_id, notification_type_id),
    INDEX idx_user_notification_preferences_user_id (user_id),
    INDEX idx_user_notification_preferences_type_id (notification_type_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Insert default notification types
INSERT INTO notification_types (name, description, template) VALUES
('proposal_created', 'New proposal created', 'A new proposal "{{title}}" has been created by {{proposer}}'),
('proposal_ending', 'Proposal ending soon', 'Proposal "{{title}}" is ending in {{time_remaining}}'),
('proposal_passed', 'Proposal passed', 'Proposal "{{title}}" has passed with {{yes_votes}} yes votes'),
('proposal_rejected', 'Proposal rejected', 'Proposal "{{title}}" has been rejected with {{no_votes}} no votes'),
('vote_cast', 'Vote cast', 'Your vote has been cast for proposal "{{title}}"'),
('balance_updated', 'Balance updated', 'Your {{token}} balance has been updated to {{balance}}'),
('transaction_confirmed', 'Transaction confirmed', 'Your transaction {{tx_hash}} has been confirmed'),
('transaction_failed', 'Transaction failed', 'Your transaction {{tx_hash}} has failed');

-- Down Migration
-- =============

DROP TABLE IF EXISTS user_notification_preferences;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS notification_types;
```

## Data Migrations

### Migration 004: Seed Initial Data
```sql
-- Migration: 004_seed_initial_data.sql
-- Description: Seed initial data
-- Author: REChain DAO Team
-- Date: 2024-02-15
-- Version: 1.0.3

-- Up Migration
-- ===========

-- Insert default tokens
INSERT INTO tokens (symbol, name, contract_address, decimals, total_supply) VALUES
('RCH', 'REChain Token', '0x1234567890123456789012345678901234567890', 18, 1000000000.00000000),
('USDC', 'USD Coin', '0x1234567890123456789012345678901234567891', 6, 1000000000.00000000),
('USDT', 'Tether USD', '0x1234567890123456789012345678901234567892', 6, 1000000000.00000000);

-- Insert admin user
INSERT INTO users (uuid, email, username, password_hash, first_name, last_name, is_verified, is_active) VALUES
('550e8400-e29b-41d4-a716-446655440000', 'admin@rechain-dao.com', 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Admin', 'User', TRUE, TRUE);

-- Insert admin wallet
INSERT INTO wallets (user_id, address, wallet_type, is_primary, is_verified) VALUES
(1, '0x1234567890123456789012345678901234567890', 'metamask', TRUE, TRUE);

-- Insert admin token balance
INSERT INTO user_tokens (user_id, token_id, balance, locked_balance) VALUES
(1, 1, 1000000.00000000, 0.00000000);

-- Insert sample proposal
INSERT INTO proposals (uuid, title, description, proposer_id, proposal_type, status, voting_start, voting_end, quorum_threshold, approval_threshold) VALUES
('550e8400-e29b-41d4-a716-446655440001', 'Initial Governance Proposal', 'This is the first governance proposal for the REChain DAO platform. It establishes the basic governance framework and rules.', 1, 'governance', 'active', NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY), 20.00, 50.00);

-- Down Migration
-- =============

-- Remove seeded data
DELETE FROM proposals WHERE uuid = '550e8400-e29b-41d4-a716-446655440001';
DELETE FROM user_tokens WHERE user_id = 1;
DELETE FROM wallets WHERE user_id = 1;
DELETE FROM users WHERE uuid = '550e8400-e29b-41d4-a716-446655440000';
DELETE FROM tokens WHERE symbol IN ('RCH', 'USDC', 'USDT');
```

### Migration 005: Update User Tokens
```sql
-- Migration: 005_update_user_tokens.sql
-- Description: Update user token balances
-- Author: REChain DAO Team
-- Date: 2024-03-01
-- Version: 1.0.4

-- Up Migration
-- ===========

-- Update user token balances based on wallet addresses
UPDATE user_tokens ut
JOIN wallets w ON ut.user_id = w.user_id
JOIN tokens t ON ut.token_id = t.id
SET ut.balance = (
    SELECT COALESCE(SUM(amount), 0)
    FROM transactions tx
    WHERE tx.user_id = ut.user_id
    AND tx.token_id = ut.token_id
    AND tx.transaction_type IN ('deposit', 'transfer')
    AND tx.status = 'confirmed'
) - (
    SELECT COALESCE(SUM(amount), 0)
    FROM transactions tx
    WHERE tx.user_id = ut.user_id
    AND tx.token_id = ut.token_id
    AND tx.transaction_type IN ('withdrawal', 'vote')
    AND tx.status = 'confirmed'
);

-- Update locked balances for active proposals
UPDATE user_tokens ut
JOIN votes v ON ut.user_id = v.voter_id
JOIN proposals p ON v.proposal_id = p.id
SET ut.locked_balance = ut.locked_balance + v.voting_power
WHERE p.status = 'active';

-- Down Migration
-- =============

-- Reset all balances to 0
UPDATE user_tokens SET balance = 0, locked_balance = 0;
```

## Index Migrations

### Migration 006: Optimize Indexes
```sql
-- Migration: 006_optimize_indexes.sql
-- Description: Optimize database indexes for performance
-- Author: REChain DAO Team
-- Date: 2024-03-15
-- Version: 1.0.5

-- Up Migration
-- ===========

-- Analyze tables to update statistics
ANALYZE TABLE users;
ANALYZE TABLE wallets;
ANALYZE TABLE proposals;
ANALYZE TABLE votes;
ANALYZE TABLE tokens;
ANALYZE TABLE user_tokens;
ANALYZE TABLE transactions;
ANALYZE TABLE audit_logs;

-- Add covering indexes for common queries
ALTER TABLE proposals ADD INDEX idx_proposals_status_created_covering (status, created_at, id, title, proposer_id);
ALTER TABLE votes ADD INDEX idx_votes_proposal_type_covering (proposal_id, vote_type, voter_id, voting_power);
ALTER TABLE transactions ADD INDEX idx_transactions_user_created_covering (user_id, created_at, id, transaction_type, amount, status);

-- Add partial indexes for active records
ALTER TABLE users ADD INDEX idx_users_active_created (created_at) WHERE is_active = TRUE;
ALTER TABLE proposals ADD INDEX idx_proposals_active_voting (voting_start, voting_end) WHERE status = 'active';
ALTER TABLE tokens ADD INDEX idx_tokens_active_symbol (symbol) WHERE is_active = TRUE;

-- Add functional indexes
ALTER TABLE users ADD INDEX idx_users_email_lower (LOWER(email));
ALTER TABLE proposals ADD INDEX idx_proposals_title_lower (LOWER(title));

-- Down Migration
-- =============

-- Remove covering indexes
ALTER TABLE proposals DROP INDEX idx_proposals_status_created_covering;
ALTER TABLE votes DROP INDEX idx_votes_proposal_type_covering;
ALTER TABLE transactions DROP INDEX idx_transactions_user_created_covering;

-- Remove partial indexes
ALTER TABLE users DROP INDEX idx_users_active_created;
ALTER TABLE proposals DROP INDEX idx_proposals_active_voting;
ALTER TABLE tokens DROP INDEX idx_tokens_active_symbol;

-- Remove functional indexes
ALTER TABLE users DROP INDEX idx_users_email_lower;
ALTER TABLE proposals DROP INDEX idx_proposals_title_lower;
```

## Rollback Procedures

### Rollback Script
```bash
#!/bin/bash
# rollback-migration.sh

set -e

# Configuration
MIGRATION_DIR="/opt/rechain-dao/migrations"
BACKUP_DIR="/opt/rechain-dao/backups"
DB_HOST="localhost"
DB_USER="rechain_dao"
DB_NAME="rechain_dao"
DB_PASSWORD=""

# Get migration version to rollback to
TARGET_VERSION=$1

if [ -z "$TARGET_VERSION" ]; then
    echo "Usage: $0 <target_version>"
    echo "Example: $0 1.0.3"
    exit 1
fi

echo "Rolling back to version $TARGET_VERSION..."

# Get current version
CURRENT_VERSION=$(mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME -e "SELECT version FROM schema_migrations ORDER BY id DESC LIMIT 1;" -s -N)

if [ -z "$CURRENT_VERSION" ]; then
    echo "No current version found. Exiting."
    exit 1
fi

echo "Current version: $CURRENT_VERSION"
echo "Target version: $TARGET_VERSION"

# Check if target version exists
if [ ! -f "$MIGRATION_DIR/${TARGET_VERSION}_*.sql" ]; then
    echo "Target version $TARGET_VERSION not found. Exiting."
    exit 1
fi

# Create backup before rollback
echo "Creating backup before rollback..."
BACKUP_FILE="$BACKUP_DIR/rollback_backup_$(date +%Y%m%d_%H%M%S).sql"
mysqldump -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME > $BACKUP_FILE

# Get list of migrations to rollback
MIGRATIONS_TO_ROLLBACK=$(ls $MIGRATION_DIR/*.sql | sort -V | awk -F'/' '{print $NF}' | awk -F'_' '{print $1}' | awk -v target="$TARGET_VERSION" '$1 > target')

echo "Migrations to rollback:"
echo "$MIGRATIONS_TO_ROLLBACK"

# Confirm rollback
read -p "Are you sure you want to rollback? (yes/no): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Rollback cancelled."
    exit 1
fi

# Execute rollback
for migration in $MIGRATIONS_TO_ROLLBACK; do
    echo "Rolling back migration $migration..."
    
    # Find the migration file
    MIGRATION_FILE=$(ls $MIGRATION_DIR/${migration}_*.sql | head -1)
    
    if [ -f "$MIGRATION_FILE" ]; then
        # Extract and execute down migration
        sed -n '/^-- Down Migration/,/^-- Up Migration/p' "$MIGRATION_FILE" | sed '/^-- Up Migration/d' | mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME
        
        # Update schema_migrations table
        mysql -h$DB_HOST -u$DB_USER -p$DB_PASSWORD $DB_NAME -e "DELETE FROM schema_migrations WHERE version = '$migration';"
        
        echo "Migration $migration rolled back successfully."
    else
        echo "Migration file for $migration not found. Skipping."
    fi
done

echo "Rollback completed successfully!"
echo "Backup created at: $BACKUP_FILE"
```

## Migration Tools

### Migration Runner
```python
#!/usr/bin/env python3
# migration_runner.py

import os
import sys
import mysql.connector
from datetime import datetime
import re

class MigrationRunner:
    def __init__(self, host, user, password, database):
        self.host = host
        self.user = user
        self.password = password
        self.database = database
        self.connection = None
        
    def connect(self):
        """Connect to the database"""
        try:
            self.connection = mysql.connector.connect(
                host=self.host,
                user=self.user,
                password=self.password,
                database=self.database,
                autocommit=False
            )
            print(f"Connected to database: {self.database}")
        except mysql.connector.Error as err:
            print(f"Error connecting to database: {err}")
            sys.exit(1)
    
    def disconnect(self):
        """Disconnect from the database"""
        if self.connection and self.connection.is_connected():
            self.connection.close()
            print("Disconnected from database")
    
    def create_migrations_table(self):
        """Create schema_migrations table if it doesn't exist"""
        cursor = self.connection.cursor()
        try:
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS schema_migrations (
                    id INT AUTO_INCREMENT PRIMARY KEY,
                    version VARCHAR(20) NOT NULL UNIQUE,
                    description TEXT,
                    executed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    execution_time_ms INT,
                    INDEX idx_version (version)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
            """)
            self.connection.commit()
            print("Schema migrations table created/verified")
        except mysql.connector.Error as err:
            print(f"Error creating migrations table: {err}")
            self.connection.rollback()
            raise
        finally:
            cursor.close()
    
    def get_executed_migrations(self):
        """Get list of executed migrations"""
        cursor = self.connection.cursor()
        try:
            cursor.execute("SELECT version FROM schema_migrations ORDER BY version")
            return [row[0] for row in cursor.fetchall()]
        except mysql.connector.Error as err:
            print(f"Error getting executed migrations: {err}")
            return []
        finally:
            cursor.close()
    
    def get_pending_migrations(self, migration_dir):
        """Get list of pending migrations"""
        executed = self.get_executed_migrations()
        all_migrations = []
        
        for filename in os.listdir(migration_dir):
            if filename.endswith('.sql'):
                match = re.match(r'^(\d+\.\d+\.\d+)_', filename)
                if match:
                    version = match.group(1)
                    if version not in executed:
                        all_migrations.append((version, filename))
        
        return sorted(all_migrations, key=lambda x: x[0])
    
    def parse_migration_file(self, filepath):
        """Parse migration file to extract up and down migrations"""
        with open(filepath, 'r') as file:
            content = file.read()
        
        # Extract up migration
        up_match = re.search(r'-- Up Migration\s*\n(.*?)(?=-- Down Migration)', content, re.DOTALL)
        up_migration = up_match.group(1).strip() if up_match else ""
        
        # Extract down migration
        down_match = re.search(r'-- Down Migration\s*\n(.*?)(?=-- Up Migration|$)', content, re.DOTALL)
        down_migration = down_match.group(1).strip() if down_match else ""
        
        return up_migration, down_migration
    
    def execute_migration(self, version, description, up_migration, down_migration=None):
        """Execute a migration"""
        cursor = self.connection.cursor()
        start_time = datetime.now()
        
        try:
            # Execute up migration
            if up_migration:
                for statement in up_migration.split(';'):
                    statement = statement.strip()
                    if statement:
                        cursor.execute(statement)
            
            # Record migration
            execution_time = int((datetime.now() - start_time).total_seconds() * 1000)
            cursor.execute("""
                INSERT INTO schema_migrations (version, description, execution_time_ms)
                VALUES (%s, %s, %s)
            """, (version, description, execution_time))
            
            self.connection.commit()
            print(f"Migration {version} executed successfully in {execution_time}ms")
            
        except mysql.connector.Error as err:
            print(f"Error executing migration {version}: {err}")
            self.connection.rollback()
            raise
        finally:
            cursor.close()
    
    def run_migrations(self, migration_dir):
        """Run all pending migrations"""
        self.connect()
        self.create_migrations_table()
        
        pending_migrations = self.get_pending_migrations(migration_dir)
        
        if not pending_migrations:
            print("No pending migrations found")
            return
        
        print(f"Found {len(pending_migrations)} pending migrations")
        
        for version, filename in pending_migrations:
            filepath = os.path.join(migration_dir, filename)
            print(f"Running migration: {filename}")
            
            try:
                up_migration, down_migration = self.parse_migration_file(filepath)
                
                # Extract description from filename
                description = filename.replace(f"{version}_", "").replace(".sql", "").replace("_", " ").title()
                
                self.execute_migration(version, description, up_migration, down_migration)
                
            except Exception as err:
                print(f"Error running migration {filename}: {err}")
                break
        
        self.disconnect()

if __name__ == "__main__":
    # Configuration
    HOST = os.getenv('DB_HOST', 'localhost')
    USER = os.getenv('DB_USER', 'rechain_dao')
    PASSWORD = os.getenv('DB_PASSWORD', '')
    DATABASE = os.getenv('DB_NAME', 'rechain_dao')
    MIGRATION_DIR = os.getenv('MIGRATION_DIR', '/opt/rechain-dao/migrations')
    
    # Run migrations
    runner = MigrationRunner(HOST, USER, PASSWORD, DATABASE)
    runner.run_migrations(MIGRATION_DIR)
```

### Migration Validator
```python
#!/usr/bin/env python3
# migration_validator.py

import os
import re
import sys

class MigrationValidator:
    def __init__(self, migration_dir):
        self.migration_dir = migration_dir
        self.errors = []
        self.warnings = []
    
    def validate_migration_file(self, filename):
        """Validate a single migration file"""
        filepath = os.path.join(self.migration_dir, filename)
        
        if not os.path.exists(filepath):
            self.errors.append(f"Migration file not found: {filename}")
            return
        
        with open(filepath, 'r') as file:
            content = file.read()
        
        # Check file structure
        self._check_file_structure(filename, content)
        
        # Check SQL syntax
        self._check_sql_syntax(filename, content)
        
        # Check migration format
        self._check_migration_format(filename, content)
    
    def _check_file_structure(self, filename, content):
        """Check basic file structure"""
        # Check for up migration section
        if '-- Up Migration' not in content:
            self.errors.append(f"{filename}: Missing '-- Up Migration' section")
        
        # Check for down migration section
        if '-- Down Migration' not in content:
            self.warnings.append(f"{filename}: Missing '-- Down Migration' section")
        
        # Check for proper section separation
        if content.count('-- Up Migration') > 1:
            self.errors.append(f"{filename}: Multiple '-- Up Migration' sections found")
        
        if content.count('-- Down Migration') > 1:
            self.errors.append(f"{filename}: Multiple '-- Down Migration' sections found")
    
    def _check_sql_syntax(self, filename, content):
        """Check basic SQL syntax"""
        # Extract up migration
        up_match = re.search(r'-- Up Migration\s*\n(.*?)(?=-- Down Migration)', content, re.DOTALL)
        if up_match:
            up_migration = up_match.group(1).strip()
            self._validate_sql_statements(filename, up_migration, "Up")
        
        # Extract down migration
        down_match = re.search(r'-- Down Migration\s*\n(.*?)(?=-- Up Migration|$)', content, re.DOTALL)
        if down_match:
            down_migration = down_match.group(1).strip()
            self._validate_sql_statements(filename, down_migration, "Down")
    
    def _validate_sql_statements(self, filename, migration_content, section):
        """Validate SQL statements in migration content"""
        statements = [stmt.strip() for stmt in migration_content.split(';') if stmt.strip()]
        
        for i, statement in enumerate(statements):
            # Check for basic SQL keywords
            if not any(keyword in statement.upper() for keyword in ['CREATE', 'ALTER', 'DROP', 'INSERT', 'UPDATE', 'DELETE', 'SELECT']):
                self.warnings.append(f"{filename}: {section} migration statement {i+1} may not be a valid SQL statement")
            
            # Check for dangerous operations
            if any(keyword in statement.upper() for keyword in ['DROP DATABASE', 'DROP SCHEMA', 'TRUNCATE']):
                self.warnings.append(f"{filename}: {section} migration contains potentially dangerous operation: {statement[:50]}...")
            
            # Check for missing semicolons
            if not statement.endswith(';'):
                self.warnings.append(f"{filename}: {section} migration statement {i+1} may be missing semicolon")
    
    def _check_migration_format(self, filename, content):
        """Check migration file format"""
        # Check filename format
        if not re.match(r'^\d+\.\d+\.\d+_.*\.sql$', filename):
            self.errors.append(f"{filename}: Invalid filename format. Expected: VERSION_description.sql")
        
        # Check for version in content
        version_match = re.search(r'-- Migration: (\d+\.\d+\.\d+)', content)
        if version_match:
            version = version_match.group(1)
            filename_version = filename.split('_')[0]
            if version != filename_version:
                self.errors.append(f"{filename}: Version mismatch between filename and content")
        else:
            self.warnings.append(f"{filename}: Missing version in migration header")
        
        # Check for required metadata
        required_metadata = ['-- Description:', '-- Author:', '-- Date:', '-- Version:']
        for metadata in required_metadata:
            if metadata not in content:
                self.warnings.append(f"{filename}: Missing required metadata: {metadata}")
    
    def validate_all_migrations(self):
        """Validate all migration files"""
        if not os.path.exists(self.migration_dir):
            self.errors.append(f"Migration directory not found: {self.migration_dir}")
            return
        
        migration_files = [f for f in os.listdir(self.migration_dir) if f.endswith('.sql')]
        
        if not migration_files:
            self.warnings.append("No migration files found")
            return
        
        print(f"Validating {len(migration_files)} migration files...")
        
        for filename in sorted(migration_files):
            self.validate_migration_file(filename)
        
        # Print results
        if self.errors:
            print("\nErrors found:")
            for error in self.errors:
                print(f"  ERROR: {error}")
        
        if self.warnings:
            print("\nWarnings found:")
            for warning in self.warnings:
                print(f"  WARNING: {warning}")
        
        if not self.errors and not self.warnings:
            print("All migrations validated successfully!")
        
        return len(self.errors) == 0

if __name__ == "__main__":
    migration_dir = sys.argv[1] if len(sys.argv) > 1 else '/opt/rechain-dao/migrations'
    
    validator = MigrationValidator(migration_dir)
    success = validator.validate_all_migrations()
    
    sys.exit(0 if success else 1)
```

## Conclusion

These database migration scripts provide a comprehensive framework for managing database schema changes, data migrations, and rollback procedures for the REChain DAO platform. They ensure data integrity, version control, and safe deployment of database changes.

Remember: Always test migrations in a staging environment before applying to production. Create backups before running migrations and have rollback procedures ready in case of issues.
