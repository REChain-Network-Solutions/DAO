# API Testing Guide

## Overview

This comprehensive guide provides developers and QA engineers with strategies and tools for testing the REChain DAO API endpoints effectively.

## Table of Contents

1. [Testing Environment Setup](#testing-environment-setup)
2. [API Testing Tools](#api-testing-tools)
3. [Test Cases and Scenarios](#test-cases-and-scenarios)
4. [Authentication Testing](#authentication-testing)
5. [Performance Testing](#performance-testing)
6. [Security Testing](#security-testing)
7. [Automated Testing](#automated-testing)
8. [Test Data Management](#test-data-management)
9. [Error Handling Testing](#error-handling-testing)
10. [Best Practices](#best-practices)

## Testing Environment Setup

### Environment Configuration

#### Test Environment Setup
```bash
# Create test environment
cp .env.example .env.testing

# Configure test database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=rechain_dao_test
DB_USERNAME=test_user
DB_PASSWORD=test_password

# Configure test Redis
REDIS_HOST=127.0.0.1
REDIS_PORT=6379
REDIS_DATABASE=1
```

#### Test Database Setup
```sql
-- Create test database
CREATE DATABASE rechain_dao_test;
CREATE USER 'test_user'@'localhost' IDENTIFIED BY 'test_password';
GRANT ALL PRIVILEGES ON rechain_dao_test.* TO 'test_user'@'localhost';
FLUSH PRIVILEGES;

-- Import test schema
mysql -u test_user -p rechain_dao_test < schema.sql
```

### Test Data Seeding

#### Test Data Factory
```php
// Test data factory
class TestDataFactory {
    public static function createUser($overrides = []) {
        $defaults = [
            'user_name' => 'test_user_' . uniqid(),
            'user_email' => 'test_' . uniqid() . '@example.com',
            'user_password' => password_hash('password123', PASSWORD_DEFAULT),
            'user_firstname' => 'Test',
            'user_lastname' => 'User',
            'user_verified' => 1,
            'user_registered' => date('Y-m-d H:i:s')
        ];
        
        return array_merge($defaults, $overrides);
    }
    
    public static function createPost($user_id, $overrides = []) {
        $defaults = [
            'user_id' => $user_id,
            'post_text' => 'Test post content',
            'post_type' => 'text',
            'post_privacy' => 'public',
            'post_created' => date('Y-m-d H:i:s')
        ];
        
        return array_merge($defaults, $overrides);
    }
    
    public static function createGroup($admin_id, $overrides = []) {
        $defaults = [
            'group_name' => 'Test Group ' . uniqid(),
            'group_description' => 'Test group description',
            'group_privacy' => 'public',
            'group_admin' => $admin_id,
            'group_created' => date('Y-m-d H:i:s')
        ];
        
        return array_merge($defaults, $overrides);
    }
}
```

## API Testing Tools

### Postman Collection

#### Postman Setup
```json
{
    "info": {
        "name": "REChain DAO API Tests",
        "description": "Comprehensive API testing collection",
        "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
    },
    "variable": [
        {
            "key": "base_url",
            "value": "http://localhost:8000/api",
            "type": "string"
        },
        {
            "key": "access_token",
            "value": "",
            "type": "string"
        }
    ],
    "auth": {
        "type": "bearer",
        "bearer": [
            {
                "key": "token",
                "value": "{{access_token}}",
                "type": "string"
            }
        ]
    }
}
```

#### Authentication Tests
```json
{
    "name": "Authentication Tests",
    "item": [
        {
            "name": "Login Success",
            "request": {
                "method": "POST",
                "header": [
                    {
                        "key": "Content-Type",
                        "value": "application/json"
                    }
                ],
                "body": {
                    "mode": "raw",
                    "raw": "{\n  \"email\": \"test@example.com\",\n  \"password\": \"password123\"\n}"
                },
                "url": {
                    "raw": "{{base_url}}/auth/login",
                    "host": ["{{base_url}}"],
                    "path": ["auth", "login"]
                }
            },
            "event": [
                {
                    "listen": "test",
                    "script": {
                        "exec": [
                            "pm.test('Status code is 200', function () {",
                            "    pm.response.to.have.status(200);",
                            "});",
                            "",
                            "pm.test('Response has access_token', function () {",
                            "    var jsonData = pm.response.json();",
                            "    pm.expect(jsonData).to.have.property('access_token');",
                            "    pm.globals.set('access_token', jsonData.access_token);",
                            "});"
                        ]
                    }
                }
            ]
        }
    ]
}
```

### Automated Testing with PHPUnit

#### API Test Base Class
```php
// Base API test class
abstract class APITestCase extends PHPUnit\Framework\TestCase {
    protected $base_url;
    protected $access_token;
    protected $test_user;
    
    protected function setUp(): void {
        parent::setUp();
        $this->base_url = 'http://localhost:8000/api';
        $this->createTestUser();
        $this->authenticate();
    }
    
    protected function tearDown(): void {
        $this->cleanupTestData();
        parent::tearDown();
    }
    
    protected function createTestUser() {
        $user_data = TestDataFactory::createUser();
        $this->test_user = $this->createUserInDatabase($user_data);
    }
    
    protected function authenticate() {
        $response = $this->post('/auth/login', [
            'email' => $this->test_user['user_email'],
            'password' => 'password123'
        ]);
        
        $this->assertEquals(200, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->access_token = $data['access_token'];
    }
    
    protected function get($endpoint, $headers = []) {
        $headers['Authorization'] = 'Bearer ' . $this->access_token;
        return $this->makeRequest('GET', $endpoint, $headers);
    }
    
    protected function post($endpoint, $data = [], $headers = []) {
        $headers['Authorization'] = 'Bearer ' . $this->access_token;
        $headers['Content-Type'] = 'application/json';
        return $this->makeRequest('POST', $endpoint, $headers, $data);
    }
    
    protected function put($endpoint, $data = [], $headers = []) {
        $headers['Authorization'] = 'Bearer ' . $this->access_token;
        $headers['Content-Type'] = 'application/json';
        return $this->makeRequest('PUT', $endpoint, $headers, $data);
    }
    
    protected function delete($endpoint, $headers = []) {
        $headers['Authorization'] = 'Bearer ' . $this->access_token;
        return $this->makeRequest('DELETE', $endpoint, $headers);
    }
    
    private function makeRequest($method, $endpoint, $headers = [], $data = null) {
        $url = $this->base_url . $endpoint;
        
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $this->formatHeaders($headers));
        curl_setopt($ch, CURLOPT_CUSTOMREQUEST, $method);
        
        if ($data) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        }
        
        $response = curl_exec($ch);
        $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);
        
        return new MockResponse($response, $http_code);
    }
    
    private function formatHeaders($headers) {
        $formatted = [];
        foreach ($headers as $key => $value) {
            $formatted[] = $key . ': ' . $value;
        }
        return $formatted;
    }
}
```

## Test Cases and Scenarios

### User Management Tests

#### User Registration Tests
```php
// User registration tests
class UserRegistrationTest extends APITestCase {
    public function testSuccessfulRegistration() {
        $user_data = [
            'user_name' => 'newuser123',
            'user_email' => 'newuser@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
            'user_firstname' => 'New',
            'user_lastname' => 'User'
        ];
        
        $response = $this->post('/auth/register', $user_data);
        
        $this->assertEquals(201, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        
        $this->assertArrayHasKey('user', $data);
        $this->assertArrayHasKey('access_token', $data);
        $this->assertEquals('newuser@example.com', $data['user']['user_email']);
    }
    
    public function testRegistrationWithInvalidEmail() {
        $user_data = [
            'user_name' => 'newuser123',
            'user_email' => 'invalid-email',
            'password' => 'password123',
            'password_confirmation' => 'password123'
        ];
        
        $response = $this->post('/auth/register', $user_data);
        
        $this->assertEquals(422, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('errors', $data);
        $this->assertArrayHasKey('user_email', $data['errors']);
    }
    
    public function testRegistrationWithWeakPassword() {
        $user_data = [
            'user_name' => 'newuser123',
            'user_email' => 'newuser@example.com',
            'password' => '123',
            'password_confirmation' => '123'
        ];
        
        $response = $this->post('/auth/register', $user_data);
        
        $this->assertEquals(422, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('errors', $data);
        $this->assertArrayHasKey('password', $data['errors']);
    }
}
```

#### User Profile Tests
```php
// User profile tests
class UserProfileTest extends APITestCase {
    public function testGetUserProfile() {
        $response = $this->get('/user/profile');
        
        $this->assertEquals(200, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        
        $this->assertArrayHasKey('user_id', $data);
        $this->assertArrayHasKey('user_name', $data);
        $this->assertArrayHasKey('user_email', $data);
        $this->assertEquals($this->test_user['user_id'], $data['user_id']);
    }
    
    public function testUpdateUserProfile() {
        $update_data = [
            'user_firstname' => 'Updated',
            'user_lastname' => 'Name',
            'user_biography' => 'Updated biography'
        ];
        
        $response = $this->put('/user/profile', $update_data);
        
        $this->assertEquals(200, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        
        $this->assertEquals('Updated', $data['user_firstname']);
        $this->assertEquals('Name', $data['user_lastname']);
        $this->assertEquals('Updated biography', $data['user_biography']);
    }
    
    public function testUpdateProfileWithInvalidData() {
        $update_data = [
            'user_email' => 'invalid-email'
        ];
        
        $response = $this->put('/user/profile', $update_data);
        
        $this->assertEquals(422, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('errors', $data);
    }
}
```

### Posts API Tests

#### Post Creation Tests
```php
// Post creation tests
class PostCreationTest extends APITestCase {
    public function testCreateTextPost() {
        $post_data = [
            'post_text' => 'This is a test post',
            'post_type' => 'text',
            'post_privacy' => 'public'
        ];
        
        $response = $this->post('/posts', $post_data);
        
        $this->assertEquals(201, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        
        $this->assertArrayHasKey('post_id', $data);
        $this->assertEquals('This is a test post', $data['post_text']);
        $this->assertEquals('text', $data['post_type']);
        $this->assertEquals('public', $data['post_privacy']);
    }
    
    public function testCreatePostWithMedia() {
        $post_data = [
            'post_text' => 'Post with image',
            'post_type' => 'photo',
            'post_privacy' => 'public',
            'post_media' => [
                'type' => 'image',
                'url' => 'https://example.com/image.jpg'
            ]
        ];
        
        $response = $this->post('/posts', $post_data);
        
        $this->assertEquals(201, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        
        $this->assertEquals('photo', $data['post_type']);
        $this->assertArrayHasKey('post_media', $data);
    }
    
    public function testCreatePostWithEmptyText() {
        $post_data = [
            'post_text' => '',
            'post_type' => 'text',
            'post_privacy' => 'public'
        ];
        
        $response = $this->post('/posts', $post_data);
        
        $this->assertEquals(422, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('errors', $data);
    }
}
```

#### Post Retrieval Tests
```php
// Post retrieval tests
class PostRetrievalTest extends APITestCase {
    private $test_post;
    
    protected function setUp(): void {
        parent::setUp();
        $this->test_post = $this->createTestPost();
    }
    
    public function testGetUserTimeline() {
        $response = $this->get('/posts/timeline');
        
        $this->assertEquals(200, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        
        $this->assertArrayHasKey('posts', $data);
        $this->assertIsArray($data['posts']);
        $this->assertArrayHasKey('pagination', $data);
    }
    
    public function testGetPostById() {
        $response = $this->get('/posts/' . $this->test_post['post_id']);
        
        $this->assertEquals(200, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        
        $this->assertEquals($this->test_post['post_id'], $data['post_id']);
        $this->assertEquals($this->test_post['post_text'], $data['post_text']);
    }
    
    public function testGetNonExistentPost() {
        $response = $this->get('/posts/99999');
        
        $this->assertEquals(404, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('error', $data);
    }
    
    private function createTestPost() {
        $post_data = TestDataFactory::createPost($this->test_user['user_id']);
        return $this->createPostInDatabase($post_data);
    }
}
```

## Authentication Testing

### Token-Based Authentication Tests

#### Access Token Tests
```php
// Access token tests
class AccessTokenTest extends APITestCase {
    public function testValidAccessToken() {
        $response = $this->get('/user/profile');
        
        $this->assertEquals(200, $response->getStatusCode());
    }
    
    public function testInvalidAccessToken() {
        $this->access_token = 'invalid_token';
        $response = $this->get('/user/profile');
        
        $this->assertEquals(401, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('error', $data);
    }
    
    public function testExpiredAccessToken() {
        // Create expired token
        $expired_token = $this->createExpiredToken();
        $this->access_token = $expired_token;
        
        $response = $this->get('/user/profile');
        
        $this->assertEquals(401, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertEquals('Token expired', $data['error']);
    }
    
    public function testMissingAccessToken() {
        $this->access_token = null;
        $response = $this->get('/user/profile');
        
        $this->assertEquals(401, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertEquals('Access token required', $data['error']);
    }
}
```

### Permission Tests

#### Role-Based Access Tests
```php
// Role-based access tests
class RoleBasedAccessTest extends APITestCase {
    public function testAdminAccess() {
        $this->makeUserAdmin();
        
        $response = $this->get('/admin/users');
        
        $this->assertEquals(200, $response->getStatusCode());
    }
    
    public function testRegularUserAdminAccess() {
        $response = $this->get('/admin/users');
        
        $this->assertEquals(403, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertEquals('Insufficient permissions', $data['error']);
    }
    
    public function testModeratorAccess() {
        $this->makeUserModerator();
        
        $response = $this->get('/moderator/posts');
        
        $this->assertEquals(200, $response->getStatusCode());
    }
    
    private function makeUserAdmin() {
        $this->updateUserInDatabase($this->test_user['user_id'], ['user_admin' => 1]);
    }
    
    private function makeUserModerator() {
        $this->updateUserInDatabase($this->test_user['user_id'], ['user_moderator' => 1]);
    }
}
```

## Performance Testing

### Load Testing

#### Load Test Scenarios
```php
// Load testing scenarios
class LoadTest extends APITestCase {
    public function testConcurrentRequests() {
        $concurrent_requests = 10;
        $responses = [];
        
        // Create multiple concurrent requests
        $multi_handle = curl_multi_init();
        $curl_handles = [];
        
        for ($i = 0; $i < $concurrent_requests; $i++) {
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $this->base_url . '/posts/timeline');
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
            curl_setopt($ch, CURLOPT_HTTPHEADER, [
                'Authorization: Bearer ' . $this->access_token
            ]);
            
            curl_multi_add_handle($multi_handle, $ch);
            $curl_handles[] = $ch;
        }
        
        // Execute all requests
        $running = null;
        do {
            curl_multi_exec($multi_handle, $running);
            curl_multi_select($multi_handle);
        } while ($running > 0);
        
        // Collect responses
        foreach ($curl_handles as $ch) {
            $response = curl_multi_getcontent($ch);
            $http_code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
            $responses[] = ['response' => $response, 'http_code' => $http_code];
            curl_multi_remove_handle($multi_handle, $ch);
            curl_close($ch);
        }
        
        curl_multi_close($multi_handle);
        
        // Verify all requests succeeded
        foreach ($responses as $response) {
            $this->assertEquals(200, $response['http_code']);
        }
    }
    
    public function testResponseTime() {
        $start_time = microtime(true);
        
        $response = $this->get('/posts/timeline');
        
        $end_time = microtime(true);
        $response_time = $end_time - $start_time;
        
        $this->assertEquals(200, $response->getStatusCode());
        $this->assertLessThan(2.0, $response_time, 'Response time should be less than 2 seconds');
    }
}
```

### Stress Testing

#### Stress Test Implementation
```bash
#!/bin/bash
# Stress testing script

# Test parameters
BASE_URL="http://localhost:8000/api"
CONCURRENT_USERS=50
REQUESTS_PER_USER=100
TEST_DURATION=300

# Run stress test
ab -n $((CONCURRENT_USERS * REQUESTS_PER_USER)) -c $CONCURRENT_USERS -t $TEST_DURATION $BASE_URL/posts/timeline

# Test with authentication
ab -n 1000 -c 10 -H "Authorization: Bearer YOUR_TOKEN" $BASE_URL/user/profile

# Test API endpoints
ab -n 500 -c 5 $BASE_URL/posts
ab -n 500 -c 5 $BASE_URL/users
ab -n 500 -c 5 $BASE_URL/groups
```

## Security Testing

### Input Validation Tests

#### SQL Injection Tests
```php
// SQL injection tests
class SQLInjectionTest extends APITestCase {
    public function testSQLInjectionInPostSearch() {
        $malicious_input = "'; DROP TABLE users; --";
        
        $response = $this->get('/posts/search?q=' . urlencode($malicious_input));
        
        $this->assertEquals(200, $response->getStatusCode());
        // Verify that the database is still intact
        $this->assertDatabaseHas('users', ['user_id' => $this->test_user['user_id']]);
    }
    
    public function testSQLInjectionInUserProfile() {
        $malicious_input = "'; UPDATE users SET user_admin = 1 WHERE user_id = " . $this->test_user['user_id'] . "; --";
        
        $response = $this->put('/user/profile', [
            'user_firstname' => $malicious_input
        ]);
        
        $this->assertEquals(422, $response->getStatusCode());
        // Verify that the user is not made admin
        $user = $this->getUserFromDatabase($this->test_user['user_id']);
        $this->assertEquals(0, $user['user_admin']);
    }
}
```

#### XSS Tests
```php
// XSS tests
class XSSTest extends APITestCase {
    public function testXSSInPostContent() {
        $malicious_script = '<script>alert("XSS")</script>';
        
        $response = $this->post('/posts', [
            'post_text' => $malicious_script,
            'post_type' => 'text',
            'post_privacy' => 'public'
        ]);
        
        $this->assertEquals(201, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        
        // Verify that the script is escaped
        $this->assertStringNotContainsString('<script>', $data['post_text']);
        $this->assertStringContainsString('&lt;script&gt;', $data['post_text']);
    }
    
    public function testXSSInUserProfile() {
        $malicious_script = '<img src="x" onerror="alert(\'XSS\')">';
        
        $response = $this->put('/user/profile', [
            'user_biography' => $malicious_script
        ]);
        
        $this->assertEquals(200, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        
        // Verify that the script is escaped
        $this->assertStringNotContainsString('onerror=', $data['user_biography']);
    }
}
```

## Automated Testing

### CI/CD Integration

#### GitHub Actions Workflow
```yaml
# .github/workflows/api-tests.yml
name: API Tests

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  api-tests:
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: rechain_dao_test
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
      
      redis:
        image: redis:6
        options: >-
          --health-cmd="redis-cli ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Setup PHP
      uses: shivammathur/setup-php@v2
      with:
        php-version: '8.2'
        extensions: mbstring, xml, ctype, iconv, intl, pdo_mysql, redis, gd
        coverage: xdebug
    
    - name: Install dependencies
      run: composer install --no-progress --prefer-dist --optimize-autoloader
    
    - name: Setup test database
      run: |
        mysql -h 127.0.0.1 -u root -proot -e "CREATE DATABASE rechain_dao_test;"
        mysql -h 127.0.0.1 -u root -proot rechain_dao_test < database/schema.sql
    
    - name: Run API tests
      run: |
        php vendor/bin/phpunit tests/API/
        env: |
          DB_CONNECTION=mysql
          DB_HOST=127.0.0.1
          DB_PORT=3306
          DB_DATABASE=rechain_dao_test
          DB_USERNAME=root
          DB_PASSWORD=root
          REDIS_HOST=127.0.0.1
          REDIS_PORT=6379
```

### Test Automation Scripts

#### Automated Test Runner
```bash
#!/bin/bash
# Automated test runner

# Configuration
BASE_URL="http://localhost:8000/api"
TEST_REPORT_DIR="test-reports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Create test report directory
mkdir -p $TEST_REPORT_DIR

# Run different test suites
echo "Running API tests..."

# Unit tests
phpunit tests/Unit/ --log-junit $TEST_REPORT_DIR/unit-tests-$TIMESTAMP.xml

# Integration tests
phpunit tests/Integration/ --log-junit $TEST_REPORT_DIR/integration-tests-$TIMESTAMP.xml

# API tests
phpunit tests/API/ --log-junit $TEST_REPORT_DIR/api-tests-$TIMESTAMP.xml

# Performance tests
phpunit tests/Performance/ --log-junit $TEST_REPORT_DIR/performance-tests-$TIMESTAMP.xml

# Security tests
phpunit tests/Security/ --log-junit $TEST_REPORT_DIR/security-tests-$TIMESTAMP.xml

# Generate combined report
echo "Generating test report..."
php generate-test-report.php $TEST_REPORT_DIR $TIMESTAMP

echo "Test execution completed. Reports available in $TEST_REPORT_DIR/"
```

## Test Data Management

### Test Data Cleanup

#### Database Cleanup
```php
// Test data cleanup
class TestDataCleanup {
    private $db;
    
    public function __construct($db) {
        $this->db = $db;
    }
    
    public function cleanupAfterTest() {
        $this->cleanupTestUsers();
        $this->cleanupTestPosts();
        $this->cleanupTestGroups();
        $this->cleanupTestMessages();
    }
    
    private function cleanupTestUsers() {
        $this->db->query("DELETE FROM users WHERE user_email LIKE 'test_%'");
    }
    
    private function cleanupTestPosts() {
        $this->db->query("DELETE FROM posts WHERE post_text LIKE 'Test post%'");
    }
    
    private function cleanupTestGroups() {
        $this->db->query("DELETE FROM groups WHERE group_name LIKE 'Test Group%'");
    }
    
    private function cleanupTestMessages() {
        $this->db->query("DELETE FROM messages WHERE message_text LIKE 'Test message%'");
    }
}
```

### Test Data Isolation

#### Test Database Isolation
```php
// Test database isolation
class TestDatabaseIsolation {
    private $db;
    private $original_db;
    
    public function __construct() {
        $this->original_db = config('database.default');
    }
    
    public function useTestDatabase() {
        config(['database.default' => 'testing']);
        $this->db = DB::connection('testing');
    }
    
    public function restoreOriginalDatabase() {
        config(['database.default' => $this->original_db]);
    }
    
    public function truncateAllTables() {
        $tables = [
            'users', 'posts', 'comments', 'groups', 'group_members',
            'messages', 'conversations', 'notifications', 'friends'
        ];
        
        foreach ($tables as $table) {
            $this->db->statement("TRUNCATE TABLE {$table}");
        }
    }
}
```

## Error Handling Testing

### Error Response Tests

#### HTTP Error Tests
```php
// HTTP error tests
class HTTPErrorTest extends APITestCase {
    public function test404Error() {
        $response = $this->get('/nonexistent-endpoint');
        
        $this->assertEquals(404, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('error', $data);
        $this->assertEquals('Not Found', $data['error']);
    }
    
    public function test405MethodNotAllowed() {
        $response = $this->post('/posts/1'); // Assuming GET is required
        
        $this->assertEquals(405, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('error', $data);
        $this->assertEquals('Method Not Allowed', $data['error']);
    }
    
    public function test500InternalServerError() {
        // Simulate server error by causing an exception
        $response = $this->get('/posts/error-trigger');
        
        $this->assertEquals(500, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('error', $data);
        $this->assertEquals('Internal Server Error', $data['error']);
    }
}
```

### Validation Error Tests

#### Input Validation Tests
```php
// Input validation tests
class InputValidationTest extends APITestCase {
    public function testRequiredFieldValidation() {
        $response = $this->post('/posts', [
            'post_type' => 'text',
            'post_privacy' => 'public'
            // Missing required post_text field
        ]);
        
        $this->assertEquals(422, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('errors', $data);
        $this->assertArrayHasKey('post_text', $data['errors']);
    }
    
    public function testEmailValidation() {
        $response = $this->put('/user/profile', [
            'user_email' => 'invalid-email-format'
        ]);
        
        $this->assertEquals(422, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('errors', $data);
        $this->assertArrayHasKey('user_email', $data['errors']);
    }
    
    public function testPasswordValidation() {
        $response = $this->put('/user/profile', [
            'password' => '123' // Too short
        ]);
        
        $this->assertEquals(422, $response->getStatusCode());
        $data = json_decode($response->getBody(), true);
        $this->assertArrayHasKey('errors', $data);
        $this->assertArrayHasKey('password', $data['errors']);
    }
}
```

## Best Practices

### Testing Best Practices

#### Test Organization
1. **Group Related Tests**: Organize tests by functionality
2. **Use Descriptive Names**: Test names should clearly describe what is being tested
3. **One Assertion Per Test**: Each test should verify one specific behavior
4. **Independent Tests**: Tests should not depend on each other
5. **Clean Test Data**: Always clean up test data after tests

#### Test Data Management
1. **Use Factories**: Create test data using factory classes
2. **Isolate Test Data**: Use separate test database
3. **Clean Up**: Always clean up test data after tests
4. **Realistic Data**: Use realistic test data that matches production

#### Performance Testing
1. **Set Performance Baselines**: Establish acceptable performance metrics
2. **Test Under Load**: Test with realistic concurrent users
3. **Monitor Resources**: Monitor CPU, memory, and database usage
4. **Regular Testing**: Run performance tests regularly

#### Security Testing
1. **Test All Inputs**: Test all user inputs for security vulnerabilities
2. **Test Authentication**: Verify authentication and authorization
3. **Test Error Handling**: Ensure errors don't leak sensitive information
4. **Regular Security Audits**: Perform regular security testing

### Maintenance Best Practices

#### Test Maintenance
1. **Keep Tests Updated**: Update tests when API changes
2. **Remove Obsolete Tests**: Remove tests for deprecated functionality
3. **Document Test Cases**: Document complex test scenarios
4. **Regular Review**: Regularly review and improve tests

#### Continuous Integration
1. **Automated Testing**: Run tests automatically on code changes
2. **Fast Feedback**: Ensure tests run quickly for fast feedback
3. **Test Coverage**: Maintain good test coverage
4. **Quality Gates**: Use test results as quality gates

## Conclusion

This API testing guide provides comprehensive strategies for testing the REChain DAO API effectively. Regular testing, both manual and automated, is essential for maintaining a reliable and secure API.

Remember: Testing is an ongoing process that should be integrated into the development workflow. Invest in good testing practices early to avoid issues in production.
