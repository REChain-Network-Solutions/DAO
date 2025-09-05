# Database Schema Documentation

## Overview

This document provides a comprehensive overview of the REChain DAO database schema, including table structures, relationships, indexes, and query examples.

## Database Information

- **Database Type**: MySQL
- **Version**: 8.0+
- **Character Set**: utf8mb4
- **Collation**: utf8mb4_unicode_ci
- **Engine**: InnoDB

## Core Tables

### Users Table

The central table for user management and authentication.

```sql
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `user_firstname` varchar(50) DEFAULT NULL,
  `user_lastname` varchar(50) DEFAULT NULL,
  `user_gender` enum('male','female','other') DEFAULT NULL,
  `user_birthdate` date DEFAULT NULL,
  `user_picture` varchar(255) DEFAULT NULL,
  `user_cover` varchar(255) DEFAULT NULL,
  `user_registered` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_verified` tinyint(1) NOT NULL DEFAULT '0',
  `user_relationship` enum('single','in_relationship','married','divorced','widowed') DEFAULT NULL,
  `user_biography` text,
  `user_website` varchar(255) DEFAULT NULL,
  `user_demo` tinyint(1) NOT NULL DEFAULT '0',
  `user_banned` tinyint(1) NOT NULL DEFAULT '0',
  `user_admin` tinyint(1) NOT NULL DEFAULT '0',
  `user_moderator` tinyint(1) NOT NULL DEFAULT '0',
  `user_last_seen` datetime DEFAULT NULL,
  `user_privacy` text,
  `user_notifications` text,
  `user_settings` text,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`),
  UNIQUE KEY `user_email` (`user_email`),
  KEY `user_registered` (`user_registered`),
  KEY `user_verified` (`user_verified`),
  KEY `user_banned` (`user_banned`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Posts Table

Stores user posts and content.

```sql
CREATE TABLE `posts` (
  `post_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `post_type` enum('text','photo','video','link','poll') NOT NULL DEFAULT 'text',
  `post_text` text,
  `post_media` text,
  `post_privacy` enum('public','friends','me') NOT NULL DEFAULT 'public',
  `post_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `post_updated` datetime DEFAULT NULL,
  `post_likes` int(11) NOT NULL DEFAULT '0',
  `post_comments` int(11) NOT NULL DEFAULT '0',
  `post_shares` int(11) NOT NULL DEFAULT '0',
  `post_views` int(11) NOT NULL DEFAULT '0',
  `post_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `post_boosted` tinyint(1) NOT NULL DEFAULT '0',
  `post_boosted_until` datetime DEFAULT NULL,
  PRIMARY KEY (`post_id`),
  KEY `user_id` (`user_id`),
  KEY `post_type` (`post_type`),
  KEY `post_created` (`post_created`),
  KEY `post_privacy` (`post_privacy`),
  KEY `post_boosted` (`post_boosted`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Comments Table

Stores comments on posts.

```sql
CREATE TABLE `comments` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment_text` text NOT NULL,
  `comment_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `comment_updated` datetime DEFAULT NULL,
  `comment_likes` int(11) NOT NULL DEFAULT '0',
  `comment_replies` int(11) NOT NULL DEFAULT '0',
  `comment_parent` int(11) DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`),
  KEY `comment_created` (`comment_created`),
  KEY `comment_parent` (`comment_parent`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_3` FOREIGN KEY (`comment_parent`) REFERENCES `comments` (`comment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Friends Table

Manages user friendships and connections.

```sql
CREATE TABLE `friends` (
  `friendship_id` int(11) NOT NULL AUTO_INCREMENT,
  `user1_id` int(11) NOT NULL,
  `user2_id` int(11) NOT NULL,
  `status` enum('pending','accepted','blocked') NOT NULL DEFAULT 'pending',
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`friendship_id`),
  UNIQUE KEY `unique_friendship` (`user1_id`,`user2_id`),
  KEY `user1_id` (`user1_id`),
  KEY `user2_id` (`user2_id`),
  KEY `status` (`status`),
  CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`user1_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `friends_ibfk_2` FOREIGN KEY (`user2_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Groups Table

Stores group information and settings.

```sql
CREATE TABLE `groups` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(100) NOT NULL,
  `group_description` text,
  `group_privacy` enum('public','closed','secret') NOT NULL DEFAULT 'public',
  `group_category` varchar(50) DEFAULT NULL,
  `group_cover` varchar(255) DEFAULT NULL,
  `group_picture` varchar(255) DEFAULT NULL,
  `group_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `group_updated` datetime DEFAULT NULL,
  `group_members` int(11) NOT NULL DEFAULT '0',
  `group_posts` int(11) NOT NULL DEFAULT '0',
  `group_admin` int(11) NOT NULL,
  `group_moderators` text,
  `group_settings` text,
  PRIMARY KEY (`group_id`),
  KEY `group_privacy` (`group_privacy`),
  KEY `group_category` (`group_category`),
  KEY `group_created` (`group_created`),
  KEY `group_admin` (`group_admin`),
  CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`group_admin`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Group Members Table

Manages group membership.

```sql
CREATE TABLE `group_members` (
  `membership_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` enum('admin','moderator','member') NOT NULL DEFAULT 'member',
  `joined` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('active','banned','left') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`membership_id`),
  UNIQUE KEY `unique_membership` (`group_id`,`user_id`),
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`),
  KEY `role` (`role`),
  KEY `status` (`status`),
  CONSTRAINT `group_members_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`group_id`) ON DELETE CASCADE,
  CONSTRAINT `group_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Messages Table

Stores private messages between users.

```sql
CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message_text` text,
  `message_media` text,
  `message_type` enum('text','photo','video','file','sticker') NOT NULL DEFAULT 'text',
  `message_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `message_read` tinyint(1) NOT NULL DEFAULT '0',
  `message_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`message_id`),
  KEY `conversation_id` (`conversation_id`),
  KEY `user_id` (`user_id`),
  KEY `message_created` (`message_created`),
  KEY `message_read` (`message_read`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`conversation_id`) ON DELETE CASCADE,
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Conversations Table

Manages conversation threads.

```sql
CREATE TABLE `conversations` (
  `conversation_id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_type` enum('user','group') NOT NULL DEFAULT 'user',
  `conversation_name` varchar(100) DEFAULT NULL,
  `conversation_picture` varchar(255) DEFAULT NULL,
  `conversation_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `conversation_updated` datetime DEFAULT NULL,
  `conversation_last_message` int(11) DEFAULT NULL,
  `conversation_participants` text,
  PRIMARY KEY (`conversation_id`),
  KEY `conversation_type` (`conversation_type`),
  KEY `conversation_created` (`conversation_created`),
  KEY `conversation_last_message` (`conversation_last_message`),
  CONSTRAINT `conversations_ibfk_1` FOREIGN KEY (`conversation_last_message`) REFERENCES `messages` (`message_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Notifications Table

Stores user notifications.

```sql
CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `notification_type` varchar(50) NOT NULL,
  `notification_text` text NOT NULL,
  `notification_data` text,
  `notification_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `notification_read` tinyint(1) NOT NULL DEFAULT '0',
  `notification_action_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `user_id` (`user_id`),
  KEY `notification_type` (`notification_type`),
  KEY `notification_created` (`notification_created`),
  KEY `notification_read` (`notification_read`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### System Settings Table

Stores system-wide configuration.

```sql
CREATE TABLE `system_settings` (
  `setting_id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_name` varchar(100) NOT NULL,
  `setting_value` text,
  `setting_type` enum('string','number','boolean','json') NOT NULL DEFAULT 'string',
  `setting_category` varchar(50) DEFAULT NULL,
  `setting_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  UNIQUE KEY `setting_name` (`setting_name`),
  KEY `setting_category` (`setting_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## Indexes and Performance

### Primary Indexes
- All tables have primary keys on their main ID columns
- Foreign key relationships are properly indexed
- Frequently queried columns have dedicated indexes

### Composite Indexes
- `posts`: `(user_id, post_created)` for user timeline queries
- `comments`: `(post_id, comment_created)` for post comments
- `friends`: `(user1_id, status)` for friendship queries
- `messages`: `(conversation_id, message_created)` for conversation history

### Full-Text Indexes
- `posts.post_text` for content search
- `comments.comment_text` for comment search
- `users.user_biography` for user profile search

## Query Examples

### Common Queries

#### Get User Timeline
```sql
SELECT p.*, u.user_name, u.user_picture 
FROM posts p 
JOIN users u ON p.user_id = u.user_id 
WHERE p.user_id = ? 
ORDER BY p.post_created DESC 
LIMIT 20;
```

#### Get User Friends
```sql
SELECT u.* 
FROM users u 
JOIN friends f ON u.user_id = f.user2_id 
WHERE f.user1_id = ? AND f.status = 'accepted'
UNION
SELECT u.* 
FROM users u 
JOIN friends f ON u.user_id = f.user1_id 
WHERE f.user2_id = ? AND f.status = 'accepted';
```

#### Get Group Members
```sql
SELECT u.*, gm.role, gm.joined 
FROM users u 
JOIN group_members gm ON u.user_id = gm.user_id 
WHERE gm.group_id = ? AND gm.status = 'active'
ORDER BY gm.role DESC, gm.joined ASC;
```

#### Get Unread Notifications
```sql
SELECT * 
FROM notifications 
WHERE user_id = ? AND notification_read = 0 
ORDER BY notification_created DESC;
```

#### Search Posts
```sql
SELECT p.*, u.user_name, u.user_picture 
FROM posts p 
JOIN users u ON p.user_id = u.user_id 
WHERE MATCH(p.post_text) AGAINST(? IN NATURAL LANGUAGE MODE)
ORDER BY p.post_created DESC;
```

## Data Relationships

### One-to-Many Relationships
- Users → Posts
- Users → Comments
- Users → Messages
- Users → Notifications
- Groups → Group Members
- Conversations → Messages

### Many-to-Many Relationships
- Users ↔ Users (Friends)
- Users ↔ Groups (Group Members)

### Self-Referencing Relationships
- Comments → Comments (Replies)

## Data Integrity

### Foreign Key Constraints
- All foreign keys have proper CASCADE or SET NULL actions
- Referential integrity is maintained across all relationships

### Check Constraints
- Enum values ensure data consistency
- Date constraints prevent invalid dates
- Length constraints prevent oversized data

### Triggers
- Automatic timestamp updates
- Counter updates for likes, comments, shares
- Notification generation for important events

## Backup and Recovery

### Backup Strategy
- Daily full backups
- Hourly incremental backups
- Point-in-time recovery capability

### Recovery Procedures
- Database restoration from backups
- Data consistency verification
- Service restoration steps

## Monitoring and Maintenance

### Performance Monitoring
- Query execution time tracking
- Index usage analysis
- Table size monitoring

### Maintenance Tasks
- Regular index optimization
- Table statistics updates
- Log file rotation

## Security Considerations

### Data Protection
- Sensitive data encryption
- Access control implementation
- Audit logging

### SQL Injection Prevention
- Prepared statements usage
- Input validation
- Parameterized queries

## Migration and Versioning

### Schema Versioning
- Version control for schema changes
- Migration scripts for updates
- Rollback procedures

### Data Migration
- Safe data transformation
- Validation of migrated data
- Testing procedures

## Troubleshooting

### Common Issues
- Performance bottlenecks
- Deadlock resolution
- Index optimization

### Diagnostic Queries
- System status checks
- Performance analysis
- Error investigation

## Best Practices

### Query Optimization
- Use appropriate indexes
- Avoid SELECT *
- Limit result sets

### Data Modeling
- Normalize appropriately
- Consider denormalization for performance
- Plan for scalability

### Maintenance
- Regular monitoring
- Proactive optimization
- Documentation updates
