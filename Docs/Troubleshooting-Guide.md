# REChain DAO - Troubleshooting Guide

## Table of Contents

1. [Common Issues](#common-issues)
2. [Installation Problems](#installation-problems)
3. [Database Issues](#database-issues)
4. [Performance Issues](#performance-issues)
5. [Security Issues](#security-issues)
6. [API Problems](#api-problems)
7. [Frontend Issues](#frontend-issues)
8. [Mobile App Issues](#mobile-app-issues)
9. [Email and Notifications](#email-and-notifications)
10. [File Upload Problems](#file-upload-problems)
11. [Payment Issues](#payment-issues)
12. [Advanced Troubleshooting](#advanced-troubleshooting)

## Common Issues

### Site Not Loading

#### Symptoms
- Blank page or "This site can't be reached"
- 500 Internal Server Error
- Connection timeout

#### Solutions

**Check Web Server Status:**
```bash
# Apache
sudo systemctl status apache2
sudo systemctl restart apache2

# Nginx
sudo systemctl status nginx
sudo systemctl restart nginx
```

**Check PHP Status:**
```bash
# PHP-FPM
sudo systemctl status php8.3-fpm
sudo systemctl restart php8.3-fpm

# Check PHP version
php -v
```

**Check Error Logs:**
```bash
# Apache error log
tail -f /var/log/apache2/error.log

# Nginx error log
tail -f /var/log/nginx/error.log

# PHP error log
tail -f /var/log/php8.3/error.log
```

**Verify File Permissions:**
```bash
# Set correct permissions
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo chmod -R 777 /var/www/html/content/uploads
```

### Login Issues

#### Symptoms
- "Invalid username or password" error
- Login form not submitting
- Redirect loops

#### Solutions

**Check Database Connection:**
```php
// Test database connection
$db = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT);
if ($db->connect_error) {
    die("Connection failed: " . $db->connect_error);
}
echo "Connected successfully";
```

**Verify User Data:**
```sql
-- Check if user exists
SELECT user_id, user_name, user_email FROM users WHERE user_email = 'user@example.com';

-- Check password hash
SELECT user_password FROM users WHERE user_email = 'user@example.com';
```

**Clear Session Data:**
```bash
# Clear PHP sessions
sudo rm -rf /var/lib/php/sessions/*
```

**Check Session Configuration:**
```ini
# In php.ini
session.save_path = "/var/lib/php/sessions"
session.gc_maxlifetime = 1440
```

### Registration Problems

#### Symptoms
- Registration form not working
- Email verification not sending
- "Username already exists" when it doesn't

#### Solutions

**Check Email Configuration:**
```php
// Test email sending
$to = "test@example.com";
$subject = "Test Email";
$message = "This is a test email";
$headers = "From: noreply@yourdomain.com";

if (mail($to, $subject, $message, $headers)) {
    echo "Email sent successfully";
} else {
    echo "Email sending failed";
}
```

**Verify SMTP Settings:**
```php
// In config.php
define('SMTP_HOST', 'smtp.gmail.com');
define('SMTP_PORT', 587);
define('SMTP_USERNAME', 'your-email@gmail.com');
define('SMTP_PASSWORD', 'your-app-password');
define('SMTP_ENCRYPTION', 'tls');
```

**Check Database Constraints:**
```sql
-- Check unique constraints
SHOW CREATE TABLE users;

-- Check for duplicate usernames
SELECT user_name, COUNT(*) FROM users GROUP BY user_name HAVING COUNT(*) > 1;
```

## Installation Problems

### Composer Issues

#### Symptoms
- "Composer not found" error
- Dependency installation fails
- Memory limit exceeded

#### Solutions

**Install Composer:**
```bash
# Download and install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer --version
```

**Increase Memory Limit:**
```bash
# Temporary increase
php -d memory_limit=2G /usr/local/bin/composer install

# Or set in php.ini
memory_limit = 2G
```

**Clear Composer Cache:**
```bash
composer clear-cache
composer install --no-cache
```

### Database Installation Issues

#### Symptoms
- Database connection failed
- SQL import errors
- Permission denied errors

#### Solutions

**Check MySQL Service:**
```bash
sudo systemctl status mysql
sudo systemctl start mysql
```

**Create Database and User:**
```sql
CREATE DATABASE rechain_dao CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'dao_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON rechain_dao.* TO 'dao_user'@'localhost';
FLUSH PRIVILEGES;
```

**Import Database Schema:**
```bash
mysql -u dao_user -p rechain_dao < Extras/SQL/schema.sql
```

**Check File Permissions:**
```bash
# Make sure SQL files are readable
chmod 644 Extras/SQL/*.sql
```

### File Permission Issues

#### Symptoms
- "Permission denied" errors
- Files not uploading
- Images not displaying

#### Solutions

**Set Correct Ownership:**
```bash
sudo chown -R www-data:www-data /var/www/html
```

**Set Directory Permissions:**
```bash
# Directories should be 755
find /var/www/html -type d -exec chmod 755 {} \;

# Files should be 644
find /var/www/html -type f -exec chmod 644 {} \;

# Upload directories should be 777
chmod -R 777 /var/www/html/content/uploads
chmod -R 777 /var/www/html/content/backups
```

**Check SELinux (if enabled):**
```bash
# Check SELinux status
sestatus

# Set proper context
sudo setsebool -P httpd_can_network_connect 1
sudo setsebool -P httpd_anon_write 1
```

## Database Issues

### Connection Problems

#### Symptoms
- "Can't connect to MySQL server"
- "Access denied for user"
- "Unknown database"

#### Solutions

**Test Connection:**
```bash
mysql -h localhost -u dao_user -p rechain_dao
```

**Check MySQL Configuration:**
```bash
# Check if MySQL is running
sudo systemctl status mysql

# Check MySQL configuration
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

**Verify Credentials:**
```php
// Test connection in PHP
$host = 'localhost';
$username = 'dao_user';
$password = 'secure_password';
$database = 'rechain_dao';

$connection = new mysqli($host, $username, $password, $database);

if ($connection->connect_error) {
    die("Connection failed: " . $connection->connect_error);
}
echo "Connected successfully";
```

### Query Performance Issues

#### Symptoms
- Slow page loading
- Database timeout errors
- High CPU usage

#### Solutions

**Analyze Slow Queries:**
```sql
-- Enable slow query log
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;

-- Check slow queries
SHOW VARIABLES LIKE 'slow_query_log%';
```

**Optimize Database:**
```sql
-- Analyze tables
ANALYZE TABLE users, posts, comments;

-- Optimize tables
OPTIMIZE TABLE users, posts, comments;

-- Check indexes
SHOW INDEX FROM users;
```

**Add Missing Indexes:**
```sql
-- Add indexes for common queries
CREATE INDEX idx_user_email ON users(user_email);
CREATE INDEX idx_post_created ON posts(post_created);
CREATE INDEX idx_comment_post_id ON comments(comment_post_id);
```

### Data Corruption

#### Symptoms
- Missing data
- Inconsistent data
- Foreign key constraint errors

#### Solutions

**Check Table Integrity:**
```sql
-- Check table status
CHECK TABLE users, posts, comments;

-- Repair if needed
REPAIR TABLE users, posts, comments;
```

**Backup and Restore:**
```bash
# Create backup
mysqldump -u dao_user -p rechain_dao > backup.sql

# Restore from backup
mysql -u dao_user -p rechain_dao < backup.sql
```

## Performance Issues

### Slow Page Loading

#### Symptoms
- Pages take >3 seconds to load
- Timeout errors
- High server load

#### Solutions

**Enable OPcache:**
```ini
; In php.ini
opcache.enable=1
opcache.memory_consumption=128
opcache.max_accelerated_files=4000
opcache.revalidate_freq=2
```

**Implement Caching:**
```php
// Simple file caching
function get_cached_data($key, $callback, $ttl = 3600) {
    $cache_file = "content/cache/{$key}.cache";
    
    if (file_exists($cache_file) && (time() - filemtime($cache_file)) < $ttl) {
        return unserialize(file_get_contents($cache_file));
    }
    
    $data = $callback();
    file_put_contents($cache_file, serialize($data));
    return $data;
}
```

**Optimize Images:**
```bash
# Install ImageMagick
sudo apt install imagemagick

# Optimize images
find content/uploads -name "*.jpg" -exec convert {} -quality 85 {} \;
```

### Memory Issues

#### Symptoms
- "Fatal error: Allowed memory size exhausted"
- Server crashes
- Out of memory errors

#### Solutions

**Increase PHP Memory Limit:**
```ini
; In php.ini
memory_limit = 512M
```

**Optimize Code:**
```php
// Use unset() to free memory
$large_array = get_large_data();
process_data($large_array);
unset($large_array);

// Use generators for large datasets
function get_posts_generator($limit) {
    $offset = 0;
    while ($offset < $limit) {
        $posts = get_posts_batch($offset, 100);
        foreach ($posts as $post) {
            yield $post;
        }
        $offset += 100;
    }
}
```

## Security Issues

### SQL Injection

#### Symptoms
- Unexpected database errors
- Unauthorized data access
- Malicious queries in logs

#### Solutions

**Use Prepared Statements:**
```php
// Instead of this (vulnerable)
$query = "SELECT * FROM users WHERE user_id = " . $_GET['id'];

// Use this (secure)
$stmt = $db->prepare("SELECT * FROM users WHERE user_id = ?");
$stmt->bind_param("i", $_GET['id']);
$stmt->execute();
```

**Validate Input:**
```php
function validate_input($input, $type) {
    switch ($type) {
        case 'int':
            return filter_var($input, FILTER_VALIDATE_INT);
        case 'email':
            return filter_var($input, FILTER_VALIDATE_EMAIL);
        case 'string':
            return htmlspecialchars(trim($input), ENT_QUOTES, 'UTF-8');
        default:
            return false;
    }
}
```

### XSS Attacks

#### Symptoms
- Malicious scripts in content
- Unexpected popups
- Stolen session data

#### Solutions

**Escape Output:**
```php
// Escape all output
echo htmlspecialchars($user_input, ENT_QUOTES, 'UTF-8');

// In Smarty templates
{$user_input|escape:'html'}
```

**Content Security Policy:**
```apache
# In .htaccess
Header always set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'"
```

### CSRF Attacks

#### Symptoms
- Unauthorized actions
- Unexpected form submissions
- Session hijacking

#### Solutions

**Implement CSRF Tokens:**
```php
// Generate token
function generate_csrf_token() {
    if (!isset($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

// Validate token
function validate_csrf_token($token) {
    return isset($_SESSION['csrf_token']) && 
           hash_equals($_SESSION['csrf_token'], $token);
}
```

## API Problems

### Authentication Issues

#### Symptoms
- "Unauthorized" errors
- Invalid token errors
- Session expired errors

#### Solutions

**Check Token Validity:**
```php
// Verify JWT token
function verify_jwt_token($token) {
    try {
        $decoded = JWT::decode($token, $secret_key, array('HS256'));
        return $decoded;
    } catch (Exception $e) {
        return false;
    }
}
```

**Refresh Token:**
```php
// Implement token refresh
function refresh_access_token($refresh_token) {
    // Validate refresh token
    // Generate new access token
    // Return new token pair
}
```

### Rate Limiting

#### Symptoms
- "Too Many Requests" errors
- API calls blocked
- Slow response times

#### Solutions

**Implement Rate Limiting:**
```php
function check_rate_limit($user_id, $endpoint) {
    $key = "rate_limit:{$user_id}:{$endpoint}";
    $current = $redis->get($key);
    
    if ($current === false) {
        $redis->setex($key, 3600, 1);
        return true;
    }
    
    if ($current >= 1000) { // 1000 requests per hour
        return false;
    }
    
    $redis->incr($key);
    return true;
}
```

## Frontend Issues

### JavaScript Errors

#### Symptoms
- Console errors
- Features not working
- Page not loading properly

#### Solutions

**Check Console:**
```javascript
// Enable debug mode
console.log('Debug mode enabled');

// Check for errors
window.addEventListener('error', function(e) {
    console.error('JavaScript error:', e.error);
});
```

**Validate JavaScript:**
```bash
# Use JSHint or ESLint
npm install -g jshint
jshint content/themes/default/js/*.js
```

### CSS Issues

#### Symptoms
- Styling not applied
- Layout broken
- Responsive design issues

#### Solutions

**Check CSS Loading:**
```html
<!-- Verify CSS files are loaded -->
<link rel="stylesheet" href="content/themes/default/css/main.css">
```

**Validate CSS:**
```bash
# Use CSS validator
npm install -g csslint
csslint content/themes/default/css/*.css
```

**Clear Browser Cache:**
```javascript
// Force cache refresh
location.reload(true);
```

## Mobile App Issues

### App Crashes

#### Symptoms
- App closes unexpectedly
- Black screen
- Force close errors

#### Solutions

**Check Logs:**
```bash
# Android
adb logcat | grep "REChain"

# iOS
# Use Xcode console
```

**Update App:**
- Check for app updates
- Clear app data
- Reinstall app

### Push Notifications Not Working

#### Symptoms
- No notifications received
- Notifications delayed
- Wrong notification content

#### Solutions

**Check Notification Settings:**
```javascript
// Request notification permission
if ('Notification' in window) {
    Notification.requestPermission().then(function(permission) {
        console.log('Notification permission:', permission);
    });
}
```

**Verify OneSignal Configuration:**
```php
// Check OneSignal settings
define('ONESIGNAL_APP_ID', 'your-app-id');
define('ONESIGNAL_REST_API_KEY', 'your-rest-api-key');
```

## Email and Notifications

### Email Not Sending

#### Symptoms
- Registration emails not received
- Password reset emails missing
- Notification emails not working

#### Solutions

**Test Email Configuration:**
```php
// Test email sending
$to = "test@example.com";
$subject = "Test Email";
$message = "This is a test email";
$headers = "From: noreply@yourdomain.com\r\n";
$headers .= "Reply-To: noreply@yourdomain.com\r\n";
$headers .= "X-Mailer: PHP/" . phpversion();

if (mail($to, $subject, $message, $headers)) {
    echo "Email sent successfully";
} else {
    echo "Email sending failed";
}
```

**Check SMTP Settings:**
```php
// Use PHPMailer for better email handling
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;

$mail = new PHPMailer(true);
$mail->isSMTP();
$mail->Host = 'smtp.gmail.com';
$mail->SMTPAuth = true;
$mail->Username = 'your-email@gmail.com';
$mail->Password = 'your-app-password';
$mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
$mail->Port = 587;
```

### Notification Issues

#### Symptoms
- Notifications not appearing
- Wrong notification content
- Notifications not clickable

#### Solutions

**Check Notification Settings:**
```php
// Verify notification preferences
$user_notifications = $user->get_notification_settings($user_id);
```

**Test Notification System:**
```php
// Send test notification
$user->send_notification($user_id, 'Test notification', 'This is a test');
```

## File Upload Problems

### Upload Failures

#### Symptoms
- "Upload failed" errors
- Files not appearing
- "File too large" errors

#### Solutions

**Check PHP Settings:**
```ini
; In php.ini
upload_max_filesize = 100M
post_max_size = 100M
max_execution_time = 300
max_input_time = 300
```

**Check File Permissions:**
```bash
# Ensure upload directory is writable
chmod 777 content/uploads/
chown www-data:www-data content/uploads/
```

**Validate File Types:**
```php
// Check file type
$allowed_types = ['image/jpeg', 'image/png', 'image/gif'];
$file_type = $_FILES['file']['type'];

if (!in_array($file_type, $allowed_types)) {
    throw new Exception('Invalid file type');
}
```

### Image Processing Issues

#### Symptoms
- Images not displaying
- Thumbnails not generated
- Image upload errors

#### Solutions

**Check GD Extension:**
```php
// Verify GD is installed
if (!extension_loaded('gd')) {
    die('GD extension not loaded');
}

// Check GD functions
if (!function_exists('imagecreatefromjpeg')) {
    die('GD image functions not available');
}
```

**Optimize Image Processing:**
```php
// Resize image function
function resize_image($source, $destination, $max_width, $max_height) {
    $image_info = getimagesize($source);
    $width = $image_info[0];
    $height = $image_info[1];
    
    // Calculate new dimensions
    $ratio = min($max_width/$width, $max_height/$height);
    $new_width = $width * $ratio;
    $new_height = $height * $ratio;
    
    // Create new image
    $new_image = imagecreatetruecolor($new_width, $new_height);
    $source_image = imagecreatefromjpeg($source);
    
    imagecopyresampled($new_image, $source_image, 0, 0, 0, 0, 
                      $new_width, $new_height, $width, $height);
    
    imagejpeg($new_image, $destination, 85);
    imagedestroy($new_image);
    imagedestroy($source_image);
}
```

## Payment Issues

### Payment Processing Errors

#### Symptoms
- Payment not processing
- "Payment failed" errors
- Money not received

#### Solutions

**Check Payment Gateway Configuration:**
```php
// Verify Stripe configuration
\Stripe\Stripe::setApiKey('sk_test_your_secret_key');

// Test payment
try {
    $charge = \Stripe\Charge::create([
        'amount' => 2000,
        'currency' => 'usd',
        'source' => 'tok_visa',
        'description' => 'Test payment',
    ]);
    echo "Payment successful";
} catch (Exception $e) {
    echo "Payment failed: " . $e->getMessage();
}
```

**Check Webhook Configuration:**
```php
// Verify webhook signature
$payload = @file_get_contents('php://input');
$sig_header = $_SERVER['HTTP_STRIPE_SIGNATURE'];
$endpoint_secret = 'whsec_your_webhook_secret';

try {
    $event = \Stripe\Webhook::constructEvent($payload, $sig_header, $endpoint_secret);
    // Process event
} catch (Exception $e) {
    http_response_code(400);
    exit();
}
```

## Advanced Troubleshooting

### Debug Mode

#### Enable Debug Mode
```php
// In config.php
define('DEBUGGING', true);

// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);
```

#### Debug Logging
```php
// Custom debug function
function debug_log($message, $level = 'INFO') {
    $log_file = ABSPATH . 'content/logs/debug.log';
    $timestamp = date('Y-m-d H:i:s');
    $log_entry = "[$timestamp] [$level] $message" . PHP_EOL;
    file_put_contents($log_file, $log_entry, FILE_APPEND | LOCK_EX);
}

// Usage
debug_log('User login attempt: ' . $email);
debug_log('Database error: ' . $error, 'ERROR');
```

### Performance Monitoring

#### Monitor Server Resources
```bash
# Check CPU usage
top -p $(pgrep -f php-fpm)

# Check memory usage
free -h

# Check disk usage
df -h

# Check network connections
netstat -tulpn | grep :80
```

#### Database Monitoring
```sql
-- Check active connections
SHOW PROCESSLIST;

-- Check slow queries
SHOW VARIABLES LIKE 'slow_query_log%';

-- Check table sizes
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.tables
WHERE table_schema = 'rechain_dao'
ORDER BY (data_length + index_length) DESC;
```

### Log Analysis

#### Analyze Error Logs
```bash
# Find common errors
grep -i "error" /var/log/apache2/error.log | sort | uniq -c | sort -nr

# Find PHP errors
grep -i "fatal\|warning\|notice" /var/log/php8.3/error.log | tail -20

# Monitor real-time logs
tail -f /var/log/apache2/error.log | grep -i "error"
```

#### Database Log Analysis
```bash
# Check MySQL error log
tail -f /var/log/mysql/error.log

# Check slow query log
tail -f /var/log/mysql/mysql-slow.log
```

---

*This troubleshooting guide covers the most common issues and their solutions. For additional support, please contact the development team or check the community forums.*
