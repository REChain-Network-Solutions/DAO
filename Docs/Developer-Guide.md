# REChain DAO - Developer Guide

## Table of Contents

1. [Getting Started](#getting-started)
2. [Development Environment Setup](#development-environment-setup)
3. [Code Structure](#code-structure)
4. [Database Schema](#database-schema)
5. [API Development](#api-development)
6. [Frontend Development](#frontend-development)
7. [Testing](#testing)
8. [Debugging](#debugging)
9. [Performance Optimization](#performance-optimization)
10. [Security Best Practices](#security-best-practices)
11. [Deployment](#deployment)
12. [Contributing](#contributing)

## Getting Started

### Prerequisites

Before you begin development, ensure you have:

- **PHP 8.2+** with required extensions
- **MySQL 5.7+** or **MariaDB 10.3+**
- **Composer** for dependency management
- **Node.js 16+** and **npm** for frontend assets
- **Git** for version control
- **Docker** (optional, for containerized development)

### Quick Start

1. **Clone the repository:**
   ```bash
   git clone https://github.com/REChain-Network-Solutions/DAO.git
   cd DAO
   ```

2. **Install dependencies:**
   ```bash
   composer install
   npm install
   ```

3. **Set up environment:**
   ```bash
   cp includes/config-example.php includes/config.php
   # Edit config.php with your settings
   ```

4. **Initialize database:**
   ```bash
   mysql -u root -p < Extras/SQL/schema.sql
   ```

5. **Start development server:**
   ```bash
   php -S localhost:8000
   ```

## Development Environment Setup

### Local Development with Docker

1. **Create docker-compose.yml:**
   ```yaml
   version: '3.8'
   services:
     web:
       build: .
       ports:
         - "8080:80"
       volumes:
         - .:/var/www/html
       environment:
         - DB_HOST=mysql
         - DB_NAME=rechain_dao
         - DB_USER=dao_user
         - DB_PASSWORD=password
     
     mysql:
       image: mysql:8.0
       environment:
         - MYSQL_ROOT_PASSWORD=rootpassword
         - MYSQL_DATABASE=rechain_dao
         - MYSQL_USER=dao_user
         - MYSQL_PASSWORD=password
       volumes:
         - mysql_data:/var/lib/mysql
   
   volumes:
     mysql_data:
   ```

2. **Start services:**
   ```bash
   docker-compose up -d
   ```

### IDE Configuration

#### VS Code Setup

1. **Install extensions:**
   - PHP Intelephense
   - PHP Debug
   - MySQL
   - GitLens
   - Prettier

2. **Configure settings.json:**
   ```json
   {
     "php.suggest.basic": false,
     "php.validate.enable": true,
     "php.validate.executablePath": "/usr/bin/php",
     "files.associations": {
       "*.tpl": "smarty"
     }
   }
   ```

#### PhpStorm Setup

1. **Configure PHP interpreter**
2. **Set up database connection**
3. **Enable Smarty template support**
4. **Configure code style**

## Code Structure

### Directory Organization

```
REChain-DAO/
├── admin.php                 # Admin panel entry
├── api.php                   # Main API entry
├── bootstrap.php             # Application bootstrap
├── index.php                 # Main application entry
├── includes/                 # Core system files
│   ├── class-user.php        # Main user class
│   ├── functions.php         # Core functions
│   ├── traits/              # Modular functionality
│   │   ├── AdsTrait.php
│   │   ├── ChatTrait.php
│   │   └── ...
│   └── config.php           # Configuration
├── content/                 # Static content
│   ├── themes/              # UI themes
│   │   └── default/
│   │       ├── css/
│   │       ├── js/
│   │       └── tpl/
│   ├── languages/           # Localization
│   └── uploads/             # User uploads
├── apis/                    # API implementations
│   └── php/
│       ├── modules/         # API modules
│       └── routes/          # API routes
├── modules/                 # Feature modules
├── vendor/                  # Composer dependencies
└── docs/                    # Documentation
```

### Core Classes

#### User Class (`includes/class-user.php`)

The main user class uses traits for modular functionality:

```php
class User
{
    use AdsTrait,
        AffiliatesTrait,
        AnnouncementsTrait,
        // ... other traits
    
    public $_logged_in = false;
    public $_is_admin = false;
    public $_data = [];
    
    // Core methods
    public function signin($email, $password) { }
    public function signup($data) { }
    public function get_user($user_id) { }
}
```

#### Trait System

Traits provide modular functionality:

```php
trait PostsTrait
{
    public function get_posts($offset = 0, $limit = 20, $type = 'newsfeed')
    {
        // Implementation
    }
    
    public function create_post($data)
    {
        // Implementation
    }
}
```

### Database Layer

#### Connection Management

```php
// Database connection in bootstrap.php
$db = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT);

// Query helper functions
function secure($string, $type = 'text')
{
    global $db;
    return $db->real_escape_string($string);
}

function query($sql)
{
    global $db;
    return $db->query($sql);
}
```

#### Database Schema

Key tables:
- `users` - User accounts
- `posts` - Social media posts
- `comments` - Post comments
- `messages` - Chat messages
- `groups` - User groups
- `pages` - Business pages
- `notifications` - User notifications

## API Development

### Creating New API Endpoints

1. **Create controller:**
   ```php
   // apis/php/modules/yourmodule/controller.php
   function yourFunction($req, $res)
   {
       global $user;
       
       // Validate input
       if (!isset($req->body['param'])) {
           throw new ValidationException("Parameter required");
       }
       
       // Process request
       $result = $user->your_method($req->body['param']);
       
       // Return response
       apiResponse($res, ['data' => $result]);
   }
   ```

2. **Create router:**
   ```php
   // apis/php/modules/yourmodule/router.php
   $app->post('/your-endpoint', 'yourFunction');
   ```

3. **Register routes:**
   ```php
   // apis/php/routes/modules.php
   require('modules/yourmodule/router.php');
   ```

### API Response Helpers

```php
// Success response
apiResponse($res, ['data' => $data]);

// Error response
apiError('Error message', 400);

// Validation error
throw new ValidationException('Invalid input');
```

### Authentication Middleware

```php
function requireAuth($req, $res, $next)
{
    global $user;
    
    if (!$user->_logged_in) {
        apiError('Authentication required', 401);
    }
    
    $next();
}

// Use middleware
$app->get('/protected-endpoint', 'requireAuth', 'yourFunction');
```

## Frontend Development

### Template System (Smarty)

#### Creating Templates

```smarty
{* content/themes/default/tpl/your_template.tpl *}
<div class="your-component">
    <h1>{$title}</h1>
    {if $user._logged_in}
        <p>Welcome, {$user.user_firstname}!</p>
    {/if}
</div>
```

#### Template Variables

```php
// In your PHP file
$smarty->assign('title', 'Your Title');
$smarty->assign('data', $your_data);
$smarty->display('your_template.tpl');
```

### JavaScript Development

#### Module System

```javascript
// content/themes/default/js/modules/your-module.js
(function($) {
    'use strict';
    
    var YourModule = {
        init: function() {
            this.bindEvents();
        },
        
        bindEvents: function() {
            $(document).on('click', '.your-button', this.handleClick);
        },
        
        handleClick: function(e) {
            e.preventDefault();
            // Your logic here
        }
    };
    
    $(document).ready(function() {
        YourModule.init();
    });
    
})(jQuery);
```

#### AJAX Requests

```javascript
// Using the built-in AJAX helper
$.post('ajax/your-endpoint.php', {
    param1: 'value1',
    param2: 'value2'
}, function(response) {
    if (response.error) {
        alert(response.message);
    } else {
        // Handle success
        console.log(response.data);
    }
}, 'json');
```

### CSS Development

#### SCSS Structure

```scss
// content/themes/default/scss/main.scss
@import 'variables';
@import 'mixins';
@import 'base';
@import 'components/your-component';
@import 'pages/your-page';
```

#### Component Styles

```scss
// content/themes/default/scss/components/_your-component.scss
.your-component {
    padding: 20px;
    background: $primary-color;
    
    &__title {
        font-size: 24px;
        font-weight: bold;
    }
    
    &--modifier {
        border: 1px solid $border-color;
    }
}
```

## Testing

### Unit Testing

#### PHPUnit Setup

1. **Install PHPUnit:**
   ```bash
   composer require --dev phpunit/phpunit
   ```

2. **Create test configuration:**
   ```xml
   <!-- phpunit.xml -->
   <phpunit>
       <testsuites>
           <testsuite name="Unit">
               <directory>tests/Unit</directory>
           </testsuite>
       </testsuites>
   </phpunit>
   ```

3. **Write tests:**
   ```php
   // tests/Unit/UserTest.php
   class UserTest extends PHPUnit\Framework\TestCase
   {
       public function testUserCreation()
       {
           $user = new User();
           $result = $user->create_user([
               'user_name' => 'testuser',
               'user_email' => 'test@example.com'
           ]);
           
           $this->assertTrue($result);
       }
   }
   ```

### API Testing

#### Using Postman

1. **Create collection**
2. **Set up environment variables**
3. **Create test scripts**

```javascript
// Postman test script
pm.test("Status code is 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Response has required fields", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('success');
    pm.expect(jsonData).to.have.property('data');
});
```

#### Automated API Testing

```php
// tests/Api/PostsApiTest.php
class PostsApiTest extends PHPUnit\Framework\TestCase
{
    public function testCreatePost()
    {
        $client = new GuzzleHttp\Client();
        
        $response = $client->post('http://localhost/apis/php/posts', [
            'headers' => [
                'Authorization' => 'Bearer ' . $this->access_token
            ],
            'json' => [
                'post_text' => 'Test post',
                'post_privacy' => 'public'
            ]
        ]);
        
        $this->assertEquals(200, $response->getStatusCode());
    }
}
```

## Debugging

### PHP Debugging

#### Xdebug Setup

1. **Install Xdebug:**
   ```bash
   pecl install xdebug
   ```

2. **Configure php.ini:**
   ```ini
   [xdebug]
   zend_extension=xdebug.so
   xdebug.mode=debug
   xdebug.start_with_request=yes
   xdebug.client_host=127.0.0.1
   xdebug.client_port=9003
   ```

3. **Configure VS Code:**
   ```json
   {
       "name": "Listen for Xdebug",
       "type": "php",
       "request": "launch",
       "port": 9003,
       "pathMappings": {
           "/var/www/html": "${workspaceFolder}"
       }
   }
   ```

#### Logging

```php
// Custom logging function
function debug_log($message, $level = 'INFO')
{
    $log_file = ABSPATH . 'content/logs/debug.log';
    $timestamp = date('Y-m-d H:i:s');
    $log_entry = "[$timestamp] [$level] $message" . PHP_EOL;
    file_put_contents($log_file, $log_entry, FILE_APPEND | LOCK_EX);
}

// Usage
debug_log('User login attempt: ' . $email);
debug_log('Database error: ' . $error, 'ERROR');
```

### Frontend Debugging

#### Browser Developer Tools

1. **Console debugging:**
   ```javascript
   console.log('Debug info:', data);
   console.error('Error occurred:', error);
   console.table(arrayData);
   ```

2. **Network monitoring:**
   - Check API requests
   - Monitor response times
   - Debug failed requests

#### JavaScript Error Handling

```javascript
try {
    // Your code here
    riskyOperation();
} catch (error) {
    console.error('Error:', error);
    // Show user-friendly message
    showNotification('An error occurred. Please try again.');
}
```

## Performance Optimization

### Database Optimization

#### Query Optimization

```php
// Use prepared statements
$stmt = $db->prepare("SELECT * FROM users WHERE user_id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

// Use indexes
CREATE INDEX idx_user_email ON users(user_email);
CREATE INDEX idx_post_created ON posts(post_created);

// Optimize queries
EXPLAIN SELECT * FROM posts WHERE user_id = 123 ORDER BY post_created DESC;
```

#### Caching

```php
// Simple file caching
function get_cached_data($key, $callback, $ttl = 3600)
{
    $cache_file = ABSPATH . "content/cache/{$key}.cache";
    
    if (file_exists($cache_file) && (time() - filemtime($cache_file)) < $ttl) {
        return unserialize(file_get_contents($cache_file));
    }
    
    $data = $callback();
    file_put_contents($cache_file, serialize($data));
    return $data;
}

// Usage
$posts = get_cached_data('user_posts_' . $user_id, function() use ($user_id) {
    return $user->get_posts($user_id);
});
```

### Frontend Optimization

#### Asset Optimization

```javascript
// Minify CSS and JS
npm run build

// Use CDN for libraries
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>

// Lazy load images
<img src="placeholder.jpg" data-src="actual-image.jpg" class="lazy">
```

#### Caching Headers

```apache
# .htaccess
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
    ExpiresByType image/png "access plus 1 year"
</IfModule>
```

## Security Best Practices

### Input Validation

```php
// Validate and sanitize input
function validate_email($email)
{
    return filter_var($email, FILTER_VALIDATE_EMAIL);
}

function sanitize_string($string)
{
    return htmlspecialchars(trim($string), ENT_QUOTES, 'UTF-8');
}

// Use in your code
$email = validate_email($_POST['email']);
if (!$email) {
    throw new ValidationException('Invalid email address');
}
```

### SQL Injection Prevention

```php
// Always use prepared statements
$stmt = $db->prepare("SELECT * FROM users WHERE user_email = ? AND user_password = ?");
$stmt->bind_param("ss", $email, $hashed_password);
$stmt->execute();
```

### XSS Prevention

```php
// Escape output
echo htmlspecialchars($user_input, ENT_QUOTES, 'UTF-8');

// In Smarty templates
{$user_input|escape:'html'}
```

### CSRF Protection

```php
// Generate CSRF token
function generate_csrf_token()
{
    if (!isset($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

// Validate CSRF token
function validate_csrf_token($token)
{
    return isset($_SESSION['csrf_token']) && hash_equals($_SESSION['csrf_token'], $token);
}
```

## Deployment

### Production Deployment

#### Server Requirements

- **PHP 8.2+** with OPcache enabled
- **MySQL 8.0+** with proper configuration
- **Nginx** or **Apache** with mod_rewrite
- **SSL certificate** (Let's Encrypt recommended)
- **Redis** for caching (optional but recommended)

#### Deployment Steps

1. **Prepare production environment:**
   ```bash
   # Update system
   sudo apt update && sudo apt upgrade -y
   
   # Install required packages
   sudo apt install nginx mysql-server php8.3-fpm php8.3-mysql
   ```

2. **Deploy application:**
   ```bash
   # Clone repository
   git clone https://github.com/REChain-Network-Solutions/DAO.git /var/www/html
   
   # Set permissions
   sudo chown -R www-data:www-data /var/www/html
   sudo chmod -R 755 /var/www/html
   sudo chmod -R 777 /var/www/html/content/uploads
   ```

3. **Configure web server:**
   ```nginx
   # /etc/nginx/sites-available/rechain-dao
   server {
       listen 80;
       server_name your-domain.com;
       root /var/www/html;
       index index.php;
       
       location / {
           try_files $uri $uri/ /index.php?$query_string;
       }
       
       location ~ \.php$ {
           fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
           fastcgi_index index.php;
           include fastcgi_params;
       }
   }
   ```

4. **Set up SSL:**
   ```bash
   sudo certbot --nginx -d your-domain.com
   ```

### CI/CD Pipeline

#### GitHub Actions

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    
    steps:
    - uses: actions/checkout@v2
    
    - name: Deploy to server
      uses: appleboy/ssh-action@v0.1.5
      with:
        host: ${{ secrets.HOST }}
        username: ${{ secrets.USERNAME }}
        key: ${{ secrets.SSH_KEY }}
        script: |
          cd /var/www/html
          git pull origin main
          composer install --no-dev --optimize-autoloader
          npm run build
```

## Contributing

### Development Workflow

1. **Fork the repository**
2. **Create a feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**
4. **Write tests for your changes**
5. **Run the test suite:**
   ```bash
   composer test
   npm test
   ```

6. **Commit your changes:**
   ```bash
   git commit -m "Add your feature"
   ```

7. **Push to your fork:**
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Create a Pull Request**

### Code Style Guidelines

#### PHP Code Style

- Follow PSR-12 coding standards
- Use meaningful variable and function names
- Add PHPDoc comments for functions and classes
- Keep functions small and focused

```php
/**
 * Create a new post for a user
 *
 * @param int $user_id The user ID
 * @param array $data Post data
 * @return bool|int Post ID on success, false on failure
 * @throws ValidationException
 */
public function create_post($user_id, $data)
{
    // Implementation
}
```

#### JavaScript Code Style

- Use ESLint configuration
- Follow consistent naming conventions
- Use meaningful comments
- Keep functions small and focused

```javascript
/**
 * Handle user login form submission
 * @param {Event} event - Form submit event
 */
function handleLoginSubmit(event) {
    event.preventDefault();
    // Implementation
}
```

### Pull Request Guidelines

1. **Clear description** of what the PR does
2. **Reference issues** that the PR fixes
3. **Include tests** for new functionality
4. **Update documentation** if needed
5. **Screenshots** for UI changes

### Code Review Process

1. **Automated checks** must pass
2. **At least one reviewer** approval required
3. **No merge conflicts**
4. **All tests passing**
5. **Documentation updated**

---

*This developer guide provides comprehensive information for contributing to the REChain DAO project. For specific questions or advanced topics, refer to the individual component documentation or reach out to the development team.*
