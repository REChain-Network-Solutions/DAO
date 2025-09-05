# REChain DAO - Руководство по устранению неполадок

## Содержание

1. [Частые проблемы](#частые-проблемы)
2. [Проблемы установки](#проблемы-установки)
3. [Проблемы базы данных](#проблемы-базы-данных)
4. [Проблемы производительности](#проблемы-производительности)
5. [Проблемы безопасности](#проблемы-безопасности)
6. [Проблемы API](#проблемы-api)
7. [Проблемы фронтенда](#проблемы-фронтенда)
8. [Проблемы мобильного приложения](#проблемы-мобильного-приложения)
9. [Email и уведомления](#email-и-уведомления)
10. [Проблемы загрузки файлов](#проблемы-загрузки-файлов)
11. [Проблемы платежей](#проблемы-платежей)
12. [Расширенное устранение неполадок](#расширенное-устранение-неполадок)

## Частые проблемы

### Сайт не загружается

#### Симптомы
- Пустая страница или "Не удается получить доступ к сайту"
- Ошибка 500 Internal Server Error
- Таймаут соединения

#### Решения

**Проверить статус веб-сервера:**
```bash
# Apache
sudo systemctl status apache2
sudo systemctl restart apache2

# Nginx
sudo systemctl status nginx
sudo systemctl restart nginx
```

**Проверить статус PHP:**
```bash
# PHP-FPM
sudo systemctl status php8.3-fpm
sudo systemctl restart php8.3-fpm

# Проверить версию PHP
php -v
```

**Проверить логи ошибок:**
```bash
# Лог ошибок Apache
tail -f /var/log/apache2/error.log

# Лог ошибок Nginx
tail -f /var/log/nginx/error.log

# Лог ошибок PHP
tail -f /var/log/php8.3/error.log
```

**Проверить права доступа к файлам:**
```bash
# Установить правильные права доступа
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo chmod -R 777 /var/www/html/content/uploads
```

### Проблемы с входом

#### Симптомы
- Ошибка "Неверное имя пользователя или пароль"
- Форма входа не отправляется
- Циклы перенаправления

#### Решения

**Проверить подключение к базе данных:**
```php
// Тестировать подключение к базе данных
$db = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT);
if ($db->connect_error) {
    die("Ошибка подключения: " . $db->connect_error);
}
echo "Подключение успешно";
```

**Проверить данные пользователя:**
```sql
-- Проверить, существует ли пользователь
SELECT user_id, user_name, user_email FROM users WHERE user_email = 'user@example.com';

-- Проверить хеш пароля
SELECT user_password FROM users WHERE user_email = 'user@example.com';
```

**Очистить данные сессии:**
```bash
# Очистить PHP сессии
sudo rm -rf /var/lib/php/sessions/*
```

**Проверить конфигурацию сессий:**
```ini
# В php.ini
session.save_path = "/var/lib/php/sessions"
session.gc_maxlifetime = 1440
```

### Проблемы регистрации

#### Симптомы
- Форма регистрации не работает
- Email верификация не отправляется
- "Имя пользователя уже существует" когда его нет

#### Решения

**Проверить конфигурацию email:**
```php
// Тестировать отправку email
$to = "test@example.com";
$subject = "Тестовый Email";
$message = "Это тестовый email";
$headers = "From: noreply@yourdomain.com";

if (mail($to, $subject, $message, $headers)) {
    echo "Email отправлен успешно";
} else {
    echo "Отправка email не удалась";
}
```

**Проверить настройки SMTP:**
```php
// В config.php
define('SMTP_HOST', 'smtp.gmail.com');
define('SMTP_PORT', 587);
define('SMTP_USERNAME', 'your-email@gmail.com');
define('SMTP_PASSWORD', 'your-app-password');
define('SMTP_ENCRYPTION', 'tls');
```

**Проверить ограничения базы данных:**
```sql
-- Проверить уникальные ограничения
SHOW CREATE TABLE users;

-- Проверить дублирующиеся имена пользователей
SELECT user_name, COUNT(*) FROM users GROUP BY user_name HAVING COUNT(*) > 1;
```

## Проблемы установки

### Проблемы Composer

#### Симптомы
- Ошибка "Composer не найден"
- Не удается установить зависимости
- Превышен лимит памяти

#### Решения

**Установить Composer:**
```bash
# Скачать и установить Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
composer --version
```

**Увеличить лимит памяти:**
```bash
# Временное увеличение
php -d memory_limit=2G /usr/local/bin/composer install

# Или установить в php.ini
memory_limit = 2G
```

**Очистить кэш Composer:**
```bash
composer clear-cache
composer install --no-cache
```

### Проблемы установки базы данных

#### Симптомы
- Ошибка подключения к базе данных
- Ошибки импорта SQL
- Ошибки отказа в доступе

#### Решения

**Проверить службу MySQL:**
```bash
sudo systemctl status mysql
sudo systemctl start mysql
```

**Создать базу данных и пользователя:**
```sql
CREATE DATABASE rechain_dao CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'dao_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON rechain_dao.* TO 'dao_user'@'localhost';
FLUSH PRIVILEGES;
```

**Импортировать схему базы данных:**
```bash
mysql -u dao_user -p rechain_dao < Extras/SQL/schema.sql
```

**Проверить права доступа к файлам:**
```bash
# Убедиться, что SQL файлы читаемы
chmod 644 Extras/SQL/*.sql
```

### Проблемы прав доступа к файлам

#### Симптомы
- Ошибки "Отказано в доступе"
- Файлы не загружаются
- Изображения не отображаются

#### Решения

**Установить правильного владельца:**
```bash
sudo chown -R www-data:www-data /var/www/html
```

**Установить права доступа к каталогам:**
```bash
# Каталоги должны быть 755
find /var/www/html -type d -exec chmod 755 {} \;

# Файлы должны быть 644
find /var/www/html -type f -exec chmod 644 {} \;

# Каталоги загрузки должны быть 777
chmod -R 777 /var/www/html/content/uploads
chmod -R 777 /var/www/html/content/backups
```

**Проверить SELinux (если включен):**
```bash
# Проверить статус SELinux
sestatus

# Установить правильный контекст
sudo setsebool -P httpd_can_network_connect 1
sudo setsebool -P httpd_anon_write 1
```

## Проблемы базы данных

### Проблемы подключения

#### Симптомы
- "Не удается подключиться к серверу MySQL"
- "Доступ запрещен для пользователя"
- "Неизвестная база данных"

#### Решения

**Тестировать подключение:**
```bash
mysql -h localhost -u dao_user -p rechain_dao
```

**Проверить конфигурацию MySQL:**
```bash
# Проверить, запущен ли MySQL
sudo systemctl status mysql

# Проверить конфигурацию MySQL
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

**Проверить учетные данные:**
```php
// Тестировать подключение в PHP
$host = 'localhost';
$username = 'dao_user';
$password = 'secure_password';
$database = 'rechain_dao';

$connection = new mysqli($host, $username, $password, $database);

if ($connection->connect_error) {
    die("Ошибка подключения: " . $connection->connect_error);
}
echo "Подключение успешно";
```

### Проблемы производительности запросов

#### Симптомы
- Медленная загрузка страниц
- Ошибки таймаута базы данных
- Высокое использование CPU

#### Решения

**Анализировать медленные запросы:**
```sql
-- Включить лог медленных запросов
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 2;

-- Проверить медленные запросы
SHOW VARIABLES LIKE 'slow_query_log%';
```

**Оптимизировать базу данных:**
```sql
-- Анализировать таблицы
ANALYZE TABLE users, posts, comments;

-- Оптимизировать таблицы
OPTIMIZE TABLE users, posts, comments;

-- Проверить индексы
SHOW INDEX FROM users;
```

**Добавить отсутствующие индексы:**
```sql
-- Добавить индексы для частых запросов
CREATE INDEX idx_user_email ON users(user_email);
CREATE INDEX idx_post_created ON posts(post_created);
CREATE INDEX idx_comment_post_id ON comments(comment_post_id);
```

### Повреждение данных

#### Симптомы
- Отсутствующие данные
- Несогласованные данные
- Ошибки ограничений внешнего ключа

#### Решения

**Проверить целостность таблиц:**
```sql
-- Проверить статус таблиц
CHECK TABLE users, posts, comments;

-- Восстановить при необходимости
REPAIR TABLE users, posts, comments;
```

**Резервное копирование и восстановление:**
```bash
# Создать резервную копию
mysqldump -u dao_user -p rechain_dao > backup.sql

# Восстановить из резервной копии
mysql -u dao_user -p rechain_dao < backup.sql
```

## Проблемы производительности

### Медленная загрузка страниц

#### Симптомы
- Страницы загружаются >3 секунд
- Ошибки таймаута
- Высокая нагрузка на сервер

#### Решения

**Включить OPcache:**
```ini
; В php.ini
opcache.enable=1
opcache.memory_consumption=128
opcache.max_accelerated_files=4000
opcache.revalidate_freq=2
```

**Реализовать кэширование:**
```php
// Простое файловое кэширование
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

**Оптимизировать изображения:**
```bash
# Установить ImageMagick
sudo apt install imagemagick

# Оптимизировать изображения
find content/uploads -name "*.jpg" -exec convert {} -quality 85 {} \;
```

### Проблемы памяти

#### Симптомы
- "Фатальная ошибка: исчерпан допустимый размер памяти"
- Сбои сервера
- Ошибки нехватки памяти

#### Решения

**Увеличить лимит памяти PHP:**
```ini
; В php.ini
memory_limit = 512M
```

**Оптимизировать код:**
```php
// Использовать unset() для освобождения памяти
$large_array = get_large_data();
process_data($large_array);
unset($large_array);

// Использовать генераторы для больших наборов данных
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

## Проблемы безопасности

### SQL-инъекции

#### Симптомы
- Неожиданные ошибки базы данных
- Несанкционированный доступ к данным
- Вредоносные запросы в логах

#### Решения

**Использовать подготовленные выражения:**
```php
// Вместо этого (уязвимо)
$query = "SELECT * FROM users WHERE user_id = " . $_GET['id'];

// Использовать это (безопасно)
$stmt = $db->prepare("SELECT * FROM users WHERE user_id = ?");
$stmt->bind_param("i", $_GET['id']);
$stmt->execute();
```

**Валидировать входные данные:**
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

### XSS атаки

#### Симптомы
- Вредоносные скрипты в контенте
- Неожиданные всплывающие окна
- Украденные данные сессии

#### Решения

**Экранировать вывод:**
```php
// Экранировать весь вывод
echo htmlspecialchars($user_input, ENT_QUOTES, 'UTF-8');

// В шаблонах Smarty
{$user_input|escape:'html'}
```

**Политика безопасности контента:**
```apache
# В .htaccess
Header always set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'"
```

### CSRF атаки

#### Симптомы
- Несанкционированные действия
- Неожиданные отправки форм
- Угон сессии

#### Решения

**Реализовать CSRF токены:**
```php
// Генерировать токен
function generate_csrf_token() {
    if (!isset($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

// Валидировать токен
function validate_csrf_token($token) {
    return isset($_SESSION['csrf_token']) && 
           hash_equals($_SESSION['csrf_token'], $token);
}
```

## Проблемы API

### Проблемы аутентификации

#### Симптомы
- Ошибки "Не авторизован"
- Ошибки неверного токена
- Ошибки истекшей сессии

#### Решения

**Проверить валидность токена:**
```php
// Проверить JWT токен
function verify_jwt_token($token) {
    try {
        $decoded = JWT::decode($token, $secret_key, array('HS256'));
        return $decoded;
    } catch (Exception $e) {
        return false;
    }
}
```

**Обновить токен:**
```php
// Реализовать обновление токена
function refresh_access_token($refresh_token) {
    // Валидировать refresh токен
    // Генерировать новый access токен
    // Вернуть новую пару токенов
}
```

### Ограничение скорости

#### Симптомы
- Ошибки "Слишком много запросов"
- Заблокированные API вызовы
- Медленное время ответа

#### Решения

**Реализовать ограничение скорости:**
```php
function check_rate_limit($user_id, $endpoint) {
    $key = "rate_limit:{$user_id}:{$endpoint}";
    $current = $redis->get($key);
    
    if ($current === false) {
        $redis->setex($key, 3600, 1);
        return true;
    }
    
    if ($current >= 1000) { // 1000 запросов в час
        return false;
    }
    
    $redis->incr($key);
    return true;
}
```

## Проблемы фронтенда

### Ошибки JavaScript

#### Симптомы
- Ошибки консоли
- Функции не работают
- Страница не загружается правильно

#### Решения

**Проверить консоль:**
```javascript
// Включить режим отладки
console.log('Режим отладки включен');

// Проверить на ошибки
window.addEventListener('error', function(e) {
    console.error('Ошибка JavaScript:', e.error);
});
```

**Валидировать JavaScript:**
```bash
# Использовать JSHint или ESLint
npm install -g jshint
jshint content/themes/default/js/*.js
```

### Проблемы CSS

#### Симптомы
- Стили не применяются
- Сломанная верстка
- Проблемы адаптивного дизайна

#### Решения

**Проверить загрузку CSS:**
```html
<!-- Проверить, что CSS файлы загружены -->
<link rel="stylesheet" href="content/themes/default/css/main.css">
```

**Валидировать CSS:**
```bash
# Использовать валидатор CSS
npm install -g csslint
csslint content/themes/default/css/*.css
```

**Очистить кэш браузера:**
```javascript
// Принудительно обновить кэш
location.reload(true);
```

## Проблемы мобильного приложения

### Сбои приложения

#### Симптомы
- Приложение закрывается неожиданно
- Черный экран
- Ошибки принудительного закрытия

#### Решения

**Проверить логи:**
```bash
# Android
adb logcat | grep "REChain"

# iOS
# Использовать консоль Xcode
```

**Обновить приложение:**
- Проверить обновления приложения
- Очистить данные приложения
- Переустановить приложение

### Push уведомления не работают

#### Симптомы
- Уведомления не получены
- Уведомления задерживаются
- Неправильное содержимое уведомлений

#### Решения

**Проверить настройки уведомлений:**
```javascript
// Запросить разрешение на уведомления
if ('Notification' in window) {
    Notification.requestPermission().then(function(permission) {
        console.log('Разрешение на уведомления:', permission);
    });
}
```

**Проверить конфигурацию OneSignal:**
```php
// Проверить настройки OneSignal
define('ONESIGNAL_APP_ID', 'your-app-id');
define('ONESIGNAL_REST_API_KEY', 'your-rest-api-key');
```

## Email и уведомления

### Email не отправляется

#### Симптомы
- Email регистрации не получен
- Email сброса пароля отсутствует
- Email уведомлений не работает

#### Решения

**Тестировать конфигурацию email:**
```php
// Тестировать отправку email
$to = "test@example.com";
$subject = "Тестовый Email";
$message = "Это тестовый email";
$headers = "From: noreply@yourdomain.com\r\n";
$headers .= "Reply-To: noreply@yourdomain.com\r\n";
$headers .= "X-Mailer: PHP/" . phpversion();

if (mail($to, $subject, $message, $headers)) {
    echo "Email отправлен успешно";
} else {
    echo "Отправка email не удалась";
}
```

**Проверить настройки SMTP:**
```php
// Использовать PHPMailer для лучшей обработки email
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

### Проблемы уведомлений

#### Симптомы
- Уведомления не появляются
- Неправильное содержимое уведомлений
- Уведомления не кликабельны

#### Решения

**Проверить настройки уведомлений:**
```php
// Проверить предпочтения уведомлений
$user_notifications = $user->get_notification_settings($user_id);
```

**Тестировать систему уведомлений:**
```php
// Отправить тестовое уведомление
$user->send_notification($user_id, 'Тестовое уведомление', 'Это тест');
```

## Проблемы загрузки файлов

### Сбои загрузки

#### Симптомы
- Ошибки "Загрузка не удалась"
- Файлы не появляются
- Ошибки "Файл слишком большой"

#### Решения

**Проверить настройки PHP:**
```ini
; В php.ini
upload_max_filesize = 100M
post_max_size = 100M
max_execution_time = 300
max_input_time = 300
```

**Проверить права доступа к файлам:**
```bash
# Убедиться, что каталог загрузки доступен для записи
chmod 777 content/uploads/
chown www-data:www-data content/uploads/
```

**Валидировать типы файлов:**
```php
// Проверить тип файла
$allowed_types = ['image/jpeg', 'image/png', 'image/gif'];
$file_type = $_FILES['file']['type'];

if (!in_array($file_type, $allowed_types)) {
    throw new Exception('Неверный тип файла');
}
```

### Проблемы обработки изображений

#### Симптомы
- Изображения не отображаются
- Миниатюры не генерируются
- Ошибки загрузки изображений

#### Решения

**Проверить расширение GD:**
```php
// Проверить, установлено ли GD
if (!extension_loaded('gd')) {
    die('Расширение GD не загружено');
}

// Проверить функции GD
if (!function_exists('imagecreatefromjpeg')) {
    die('Функции изображений GD недоступны');
}
```

**Оптимизировать обработку изображений:**
```php
// Функция изменения размера изображения
function resize_image($source, $destination, $max_width, $max_height) {
    $image_info = getimagesize($source);
    $width = $image_info[0];
    $height = $image_info[1];
    
    // Вычислить новые размеры
    $ratio = min($max_width/$width, $max_height/$height);
    $new_width = $width * $ratio;
    $new_height = $height * $ratio;
    
    // Создать новое изображение
    $new_image = imagecreatetruecolor($new_width, $new_height);
    $source_image = imagecreatefromjpeg($source);
    
    imagecopyresampled($new_image, $source_image, 0, 0, 0, 0, 
                      $new_width, $new_height, $width, $height);
    
    imagejpeg($new_image, $destination, 85);
    imagedestroy($new_image);
    imagedestroy($source_image);
}
```

## Проблемы платежей

### Ошибки обработки платежей

#### Симптомы
- Платеж не обрабатывается
- Ошибки "Платеж не удался"
- Деньги не получены

#### Решения

**Проверить конфигурацию платежного шлюза:**
```php
// Проверить конфигурацию Stripe
\Stripe\Stripe::setApiKey('sk_test_your_secret_key');

// Тестировать платеж
try {
    $charge = \Stripe\Charge::create([
        'amount' => 2000,
        'currency' => 'usd',
        'source' => 'tok_visa',
        'description' => 'Тестовый платеж',
    ]);
    echo "Платеж успешен";
} catch (Exception $e) {
    echo "Платеж не удался: " . $e->getMessage();
}
```

**Проверить конфигурацию webhook:**
```php
// Проверить подпись webhook
$payload = @file_get_contents('php://input');
$sig_header = $_SERVER['HTTP_STRIPE_SIGNATURE'];
$endpoint_secret = 'whsec_your_webhook_secret';

try {
    $event = \Stripe\Webhook::constructEvent($payload, $sig_header, $endpoint_secret);
    // Обработать событие
} catch (Exception $e) {
    http_response_code(400);
    exit();
}
```

## Расширенное устранение неполадок

### Режим отладки

#### Включить режим отладки
```php
// В config.php
define('DEBUGGING', true);

// Включить отчетность об ошибках
error_reporting(E_ALL);
ini_set('display_errors', 1);
```

#### Логирование отладки
```php
// Пользовательская функция отладки
function debug_log($message, $level = 'INFO') {
    $log_file = ABSPATH . 'content/logs/debug.log';
    $timestamp = date('Y-m-d H:i:s');
    $log_entry = "[$timestamp] [$level] $message" . PHP_EOL;
    file_put_contents($log_file, $log_entry, FILE_APPEND | LOCK_EX);
}

// Использование
debug_log('Попытка входа пользователя: ' . $email);
debug_log('Ошибка базы данных: ' . $error, 'ERROR');
```

### Мониторинг производительности

#### Мониторинг ресурсов сервера
```bash
# Проверить использование CPU
top -p $(pgrep -f php-fpm)

# Проверить использование памяти
free -h

# Проверить использование диска
df -h

# Проверить сетевые соединения
netstat -tulpn | grep :80
```

#### Мониторинг базы данных
```sql
-- Проверить активные соединения
SHOW PROCESSLIST;

-- Проверить медленные запросы
SHOW VARIABLES LIKE 'slow_query_log%';

-- Проверить размеры таблиц
SELECT 
    table_name,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Size (MB)'
FROM information_schema.tables
WHERE table_schema = 'rechain_dao'
ORDER BY (data_length + index_length) DESC;
```

### Анализ логов

#### Анализ логов ошибок
```bash
# Найти частые ошибки
grep -i "error" /var/log/apache2/error.log | sort | uniq -c | sort -nr

# Найти ошибки PHP
grep -i "fatal\|warning\|notice" /var/log/php8.3/error.log | tail -20

# Мониторить логи в реальном времени
tail -f /var/log/apache2/error.log | grep -i "error"
```

#### Анализ логов базы данных
```bash
# Проверить лог ошибок MySQL
tail -f /var/log/mysql/error.log

# Проверить лог медленных запросов
tail -f /var/log/mysql/mysql-slow.log
```

---

*Это руководство по устранению неполадок охватывает наиболее частые проблемы и их решения. Для дополнительной поддержки, пожалуйста, обратитесь к команде разработки или проверьте форумы сообщества.*
