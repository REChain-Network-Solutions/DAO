# REChain DAO - API Documentation

## Overview

The REChain DAO API provides a comprehensive RESTful interface for interacting with the social networking platform. The API is built using a modular architecture with Express.js-inspired routing and supports both web and mobile applications.

## Base URL

```
https://your-domain.com/apis/php
```

## Authentication

### OAuth 2.0 Flow

The API uses OAuth 2.0 for authentication with the following flow:

1. **Get Authorization Code**
   ```
   GET /oauth?app_id={app_id}
   ```

2. **Exchange Code for Access Token**
   ```
   POST /authorize
   Content-Type: application/json
   
   {
     "app_id": "your_app_id",
     "app_secret": "your_app_secret",
     "auth_key": "authorization_code"
   }
   ```

3. **Use Access Token**
   Include the access token in requests:
   ```
   Authorization: Bearer {access_token}
   ```

### API Key Authentication

For server-to-server communication, you can use API keys:

```
X-API-Key: your_api_key
```

## Response Format

All API responses follow a consistent JSON format:

### Success Response
```json
{
  "success": true,
  "data": {
    // Response data
  },
  "message": "Success message"
}
```

### Error Response
```json
{
  "error": true,
  "message": "Error description",
  "code": "ERROR_CODE"
}
```

## Core Endpoints

### Health Check

#### Ping
```http
GET /ping
```

**Response:**
```json
{
  "message": "pong"
}
```

### Error Endpoints

- `GET /400` - Bad Request
- `GET /401` - Unauthorized
- `GET /403` - Forbidden
- `GET /404` - Not Found
- `GET /500` - Internal Server Error

## User Management API

### Authentication

#### Login
```http
POST /auth/login
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
    "access_token": "jwt_token_here",
    "user": {
      "user_id": 123,
      "user_name": "john_doe",
      "user_email": "user@example.com",
      "user_firstname": "John",
      "user_lastname": "Doe",
      "user_picture": "profile_pic.jpg",
      "user_verified": true
    }
  }
}
```

#### Register
```http
POST /auth/register
Content-Type: application/json

{
  "user_name": "john_doe",
  "user_email": "user@example.com",
  "user_password": "password123",
  "user_firstname": "John",
  "user_lastname": "Doe",
  "user_gender": "male",
  "user_birthdate": "1990-01-01"
}
```

#### Logout
```http
POST /auth/logout
Authorization: Bearer {access_token}
```

### User Profile

#### Get User Info
```http
GET /user/info?access_token={access_token}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user_id": 123,
    "user_name": "john_doe",
    "user_email": "user@example.com",
    "user_firstname": "John",
    "user_lastname": "Doe",
    "user_gender": "Male",
    "user_birthdate": "1990-01-01",
    "profile_picture": "https://domain.com/uploads/profile_pic.jpg",
    "profile_cover": "https://domain.com/uploads/cover.jpg",
    "user_registered": "2023-01-01 12:00:00",
    "user_verified": true,
    "user_relationship": "Single",
    "user_biography": "User bio",
    "user_website": "https://example.com"
  }
}
```

#### Update Profile
```http
PUT /user/profile
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "user_firstname": "John",
  "user_lastname": "Doe",
  "user_biography": "Updated bio",
  "user_website": "https://newwebsite.com"
}
```

#### Upload Avatar
```http
POST /user/avatar
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

file: [image_file]
```

#### Delete Avatar/Cover
```http
DELETE /user/avatar-cover
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "handle": "avatar" // or "cover"
}
```

### User Connections

#### Connect User
```http
POST /user/connect
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "do": "follow", // follow, unfollow, block, unblock
  "id": 456, // target user ID
  "uid": 789 // optional: specific user ID
}
```

#### Get User Connections
```http
GET /user/connections?type=followers&user_id=123
Authorization: Bearer {access_token}
```

## Posts API

### Create Post
```http
POST /posts
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "post_text": "This is my post content",
  "post_privacy": "public", // public, friends, me
  "post_type": "text", // text, photo, video, link
  "post_photos": ["photo1.jpg", "photo2.jpg"], // optional
  "post_video": "video.mp4", // optional
  "post_link": "https://example.com", // optional
  "post_link_title": "Link Title", // optional
  "post_link_description": "Link description", // optional
  "post_link_image": "link_image.jpg" // optional
}
```

### Get Posts
```http
GET /posts?offset=0&limit=20&type=newsfeed
Authorization: Bearer {access_token}
```

**Query Parameters:**
- `offset` - Number of posts to skip (default: 0)
- `limit` - Number of posts to return (default: 20)
- `type` - Type of posts (newsfeed, profile, page, group)
- `user_id` - User ID for profile posts
- `page_id` - Page ID for page posts
- `group_id` - Group ID for group posts

### Get Single Post
```http
GET /posts/{post_id}
Authorization: Bearer {access_token}
```

### Update Post
```http
PUT /posts/{post_id}
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "post_text": "Updated post content",
  "post_privacy": "friends"
}
```

### Delete Post
```http
DELETE /posts/{post_id}
Authorization: Bearer {access_token}
```

### Post Interactions

#### Like Post
```http
POST /posts/{post_id}/like
Authorization: Bearer {access_token}
```

#### Unlike Post
```http
DELETE /posts/{post_id}/like
Authorization: Bearer {access_token}
```

#### Comment on Post
```http
POST /posts/{post_id}/comments
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "comment_text": "This is a comment"
}
```

#### Get Post Comments
```http
GET /posts/{post_id}/comments?offset=0&limit=20
Authorization: Bearer {access_token}
```

## Chat API

### Get Conversations
```http
GET /chat/conversations
Authorization: Bearer {access_token}
```

### Get Messages
```http
GET /chat/conversations/{conversation_id}/messages?offset=0&limit=50
Authorization: Bearer {access_token}
```

### Send Message
```http
POST /chat/conversations/{conversation_id}/messages
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "message_text": "Hello!",
  "message_type": "text" // text, image, video, file
}
```

### Send File Message
```http
POST /chat/conversations/{conversation_id}/messages
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

message_text: "Check this file"
message_type: "file"
file: [file_data]
```

### Mark Messages as Read
```http
PUT /chat/conversations/{conversation_id}/read
Authorization: Bearer {access_token}
```

## Groups API

### Create Group
```http
POST /groups
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "group_name": "My Group",
  "group_title": "Group Title",
  "group_description": "Group description",
  "group_privacy": "public", // public, closed, secret
  "group_category": 1
}
```

### Get Groups
```http
GET /groups?offset=0&limit=20&type=joined
Authorization: Bearer {access_token}
```

**Query Parameters:**
- `type` - joined, suggested, search
- `search` - Search term
- `category` - Category ID

### Join Group
```http
POST /groups/{group_id}/join
Authorization: Bearer {access_token}
```

### Leave Group
```http
DELETE /groups/{group_id}/join
Authorization: Bearer {access_token}
```

## Pages API

### Create Page
```http
POST /pages
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "page_name": "my_page",
  "page_title": "My Page",
  "page_description": "Page description",
  "page_category": 1
}
```

### Get Pages
```http
GET /pages?offset=0&limit=20&type=liked
Authorization: Bearer {access_token}
```

### Like Page
```http
POST /pages/{page_id}/like
Authorization: Bearer {access_token}
```

## Notifications API

### Get Notifications
```http
GET /notifications?offset=0&limit=20&type=all
Authorization: Bearer {access_token}
```

**Query Parameters:**
- `type` - all, likes, comments, follows, mentions

### Mark Notification as Read
```http
PUT /notifications/{notification_id}/read
Authorization: Bearer {access_token}
```

### Mark All Notifications as Read
```http
PUT /notifications/read-all
Authorization: Bearer {access_token}
```

## Search API

### Search Users
```http
GET /search/users?q=john&offset=0&limit=20
Authorization: Bearer {access_token}
```

### Search Posts
```http
GET /search/posts?q=keyword&offset=0&limit=20
Authorization: Bearer {access_token}
```

### Search Groups
```http
GET /search/groups?q=group_name&offset=0&limit=20
Authorization: Bearer {access_token}
```

## File Upload API

### Upload Image
```http
POST /upload/image
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

file: [image_file]
```

**Response:**
```json
{
  "success": true,
  "data": {
    "file_name": "uploaded_image.jpg",
    "file_url": "https://domain.com/uploads/image.jpg"
  }
}
```

### Upload Video
```http
POST /upload/video
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

file: [video_file]
```

### Upload File
```http
POST /upload/file
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

file: [file_data]
```

## Monetization API

### Get Wallet Balance
```http
GET /wallet/balance
Authorization: Bearer {access_token}
```

### Get Transactions
```http
GET /wallet/transactions?offset=0&limit=20
Authorization: Bearer {access_token}
```

### Create Payment
```http
POST /payments
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "amount": 100.00,
  "currency": "USD",
  "description": "Payment description",
  "payment_method": "stripe"
}
```

## Rate Limiting

The API implements rate limiting to ensure fair usage:

- **General API**: 1000 requests per hour per user
- **Authentication**: 10 requests per minute per IP
- **File Upload**: 50 requests per hour per user
- **Search**: 100 requests per hour per user

Rate limit headers are included in responses:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
```

## Error Codes

| Code | Description |
|------|-------------|
| 400 | Bad Request - Invalid parameters |
| 401 | Unauthorized - Invalid or missing authentication |
| 403 | Forbidden - Insufficient permissions |
| 404 | Not Found - Resource not found |
| 422 | Unprocessable Entity - Validation errors |
| 429 | Too Many Requests - Rate limit exceeded |
| 500 | Internal Server Error - Server error |

## SDKs and Libraries

### JavaScript/Node.js
```bash
npm install rechain-dao-sdk
```

```javascript
const RechainDAO = require('rechain-dao-sdk');

const client = new RechainDAO({
  baseURL: 'https://your-domain.com/apis/php',
  apiKey: 'your_api_key'
});

// Login
const user = await client.auth.login({
  email: 'user@example.com',
  password: 'password123'
});
```

### PHP
```bash
composer require rechain/dao-sdk
```

```php
use Rechain\DAO\Client;

$client = new Client([
    'base_url' => 'https://your-domain.com/apis/php',
    'api_key' => 'your_api_key'
]);

// Login
$user = $client->auth->login([
    'email' => 'user@example.com',
    'password' => 'password123'
]);
```

## Webhooks

The API supports webhooks for real-time notifications:

### Webhook Events
- `user.created` - New user registration
- `post.created` - New post created
- `post.liked` - Post liked
- `comment.created` - New comment
- `message.sent` - New message sent
- `notification.created` - New notification

### Webhook Configuration
```http
POST /webhooks
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "url": "https://your-app.com/webhook",
  "events": ["user.created", "post.created"],
  "secret": "webhook_secret"
}
```

## Testing

### Postman Collection
A Postman collection is available for testing the API:
- Download: [API Collection](https://github.com/REChain-Network-Solutions/DAO/tree/main/docs/postman)
- Import into Postman and configure your environment variables

### API Testing Tools
- **Postman**: GUI-based API testing
- **curl**: Command-line testing
- **Insomnia**: Alternative GUI tool
- **Newman**: CLI for Postman collections

## Support

For API support and questions:
- **Documentation**: Check this documentation
- **Issues**: Report on GitHub Issues
- **Email**: api-support@rechain.network
- **Discord**: Join our developer community

---

*This API documentation covers the main endpoints and functionality. For additional details and advanced usage, refer to the individual module documentation.*
