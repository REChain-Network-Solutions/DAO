# REChain DAO - Руководство по развертыванию

## Содержание

1. [Обзор](#обзор)
2. [Чек-лист перед развертыванием](#чек-лист-перед-развертыванием)
3. [Настройка окружения](#настройка-окружения)
4. [Конфигурация базы данных](#конфигурация-базы-данных)
5. [Конфигурация веб-сервера](#конфигурация-веб-сервера)
6. [Настройка SSL сертификата](#настройка-ssl-сертификата)
7. [Развертывание приложения](#развертывание-приложения)
8. [Мониторинг и логирование](#мониторинг-и-логирование)
9. [Стратегия резервного копирования](#стратегия-резервного-копирования)
10. [Масштабирование и производительность](#масштабирование-и-производительность)
11. [Усиление безопасности](#усиление-безопасности)
12. [Устранение неполадок](#устранение-неполадок)

## Обзор

Это руководство охватывает полный процесс развертывания REChain DAO, от первоначальной настройки сервера до развертывания в продакшене с процедурами мониторинга и обслуживания.

### Архитектура развертывания

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Балансировщик │────│   Веб-серверы   │────│  База данных    │
│   (Nginx/HAProxy)│    │   (Apache/Nginx)│    │  (MySQL/MariaDB)│
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   CDN           │    │   Кэш Redis     │    │   Файловое      │
│   (CloudFlare)  │    │   (Опционально) │    │   хранилище     │
│                 │    │                 │    │   (S3/Локальное)│
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## Чек-лист перед развертыванием

### Требования к серверу

**Минимальные требования для продакшена:**
- **CPU**: 2 ядра, 2.4GHz
- **ОЗУ**: 4 ГБ
- **Хранилище**: 50 ГБ SSD
- **Сеть**: 100 Мбит/с
- **ОС**: Ubuntu 20.04 LTS или CentOS 8

**Рекомендуемые требования для продакшена:**
- **CPU**: 4+ ядра, 3.0GHz
- **ОЗУ**: 8 ГБ+
- **Хранилище**: 100 ГБ+ SSD
- **Сеть**: 1 Гбит/с
- **ОС**: Ubuntu 22.04 LTS

### Требования к программному обеспечению

- **PHP**: 8.2+ с необходимыми расширениями
- **Веб-сервер**: Apache 2.4+ или Nginx 1.18+
- **База данных**: MySQL 8.0+ или MariaDB 10.6+
- **Кэш**: Redis 6.0+ (опционально, но рекомендуется)
- **SSL**: Let's Encrypt или коммерческий сертификат

### Домен и DNS

- **Доменное имя** зарегистрировано и настроено
- **DNS записи** указывают на IP сервера
- **Поддомен** для API (api.yourdomain.com)
- **Email** настроен для уведомлений

## Настройка окружения

### Инициализация сервера

#### Настройка Ubuntu 22.04

```bash
# Обновить систему
sudo apt update && sudo apt upgrade -y

# Установить основные пакеты
sudo apt install -y curl wget git unzip software-properties-common

# Добавить репозиторий PHP
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update

# Установить PHP и расширения
sudo apt install -y php8.3 php8.3-fpm php8.3-mysql php8.3-curl \
    php8.3-mbstring php8.3-gd php8.3-zip php8.3-xml php8.3-intl \
    php8.3-opcache php8.3-redis php8.3-imagick

# Установить веб-сервер
sudo apt install -y nginx

# Установить базу данных
sudo apt install -y mysql-server

# Установить Redis (опционально)
sudo apt install -y redis-server

# Установить Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer

# Установить Node.js
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```

#### Настройка CentOS 8

```bash
# Обновить систему
sudo dnf update -y

# Установить репозиторий EPEL
sudo dnf install -y epel-release

# Установить репозиторий Remi
sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-8.rpm

# Включить модуль PHP 8.3
sudo dnf module enable php:remi-8.3 -y

# Установить пакеты
sudo dnf install -y php php-fpm php-mysqlnd php-curl php-mbstring \
    php-gd php-zip php-xml php-intl php-opcache php-redis \
    nginx mysql-server redis nodejs npm git

# Установить Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

### Пользователь и права доступа

```bash
# Создать пользователя приложения
sudo useradd -r -s /bin/false -d /var/www/html -m www-data

# Создать каталог приложения
sudo mkdir -p /var/www/html
sudo chown -R www-data:www-data /var/www/html

# Установить правильные права доступа
sudo chmod -R 755 /var/www/html
sudo chmod -R 777 /var/www/html/content/uploads
sudo chmod -R 777 /var/www/html/content/backups
```

## Конфигурация базы данных

### Настройка MySQL

#### Установить и защитить MySQL

```bash
# Запустить службу MySQL
sudo systemctl start mysql
sudo systemctl enable mysql

# Защитить установку MySQL
sudo mysql_secure_installation
```

#### Создать базу данных и пользователя

```sql
-- Подключиться к MySQL
sudo mysql -u root -p

-- Создать базу данных
CREATE DATABASE rechain_dao CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Создать пользователя
CREATE USER 'dao_user'@'localhost' IDENTIFIED BY 'secure_password_here';

-- Предоставить привилегии
GRANT ALL PRIVILEGES ON rechain_dao.* TO 'dao_user'@'localhost';
FLUSH PRIVILEGES;

-- Выйти из MySQL
EXIT;
```

#### Оптимизировать конфигурацию MySQL

```bash
# Редактировать конфигурацию MySQL
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
```

```ini
[mysqld]
# Основные настройки
bind-address = 127.0.0.1
port = 3306
socket = /var/run/mysqld/mysqld.sock

# Настройки производительности
innodb_buffer_pool_size = 1G
innodb_log_file_size = 256M
innodb_flush_log_at_trx_commit = 2
innodb_flush_method = O_DIRECT

# Настройки соединений
max_connections = 200
max_connect_errors = 1000
wait_timeout = 28800
interactive_timeout = 28800

# Кэш запросов
query_cache_type = 1
query_cache_size = 64M
query_cache_limit = 2M

# Логирование
slow_query_log = 1
slow_query_log_file = /var/log/mysql/mysql-slow.log
long_query_time = 2

# Безопасность
local_infile = 0
```

```bash
# Перезапустить MySQL
sudo systemctl restart mysql
```

### Конфигурация Redis (опционально)

```bash
# Редактировать конфигурацию Redis
sudo nano /etc/redis/redis.conf
```

```ini
# Основные настройки
bind 127.0.0.1
port 6379
timeout 300

# Настройки памяти
maxmemory 256mb
maxmemory-policy allkeys-lru

# Персистентность
save 900 1
save 300 10
save 60 10000

# Безопасность
requirepass your_redis_password
```

```bash
# Перезапустить Redis
sudo systemctl restart redis
```

## Конфигурация веб-сервера

### Конфигурация Nginx

#### Основная конфигурация

```bash
# Редактировать конфигурацию Nginx
sudo nano /etc/nginx/nginx.conf
```

```nginx
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
    worker_connections 1024;
    use epoll;
    multi_accept on;
}

http {
    # Основные настройки
    sendfile on;
    tcp_nopush on;
    tcp_nodelay on;
    keepalive_timeout 65;
    types_hash_max_size 2048;
    server_tokens off;

    # MIME типы
    include /etc/nginx/mime.types;
    default_type application/octet-stream;

    # Логирование
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;
    error_log /var/log/nginx/error.log;

    # Сжатие Gzip
    gzip on;
    gzip_vary on;
    gzip_proxied any;
    gzip_comp_level 6;
    gzip_types
        text/plain
        text/css
        text/xml
        text/javascript
        application/json
        application/javascript
        application/xml+rss
        application/atom+xml
        image/svg+xml;

    # Ограничение скорости
    limit_req_zone $binary_remote_addr zone=api:10m rate=10r/s;
    limit_req_zone $binary_remote_addr zone=login:10m rate=5r/m;

    # Включить конфигурации сайтов
    include /etc/nginx/conf.d/*.conf;
    include /etc/nginx/sites-enabled/*;
}
```

#### Конфигурация сайта

```bash
# Создать конфигурацию сайта
sudo nano /etc/nginx/sites-available/rechain-dao
```

```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    root /var/www/html;
    index index.php index.html;

    # Заголовки безопасности
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
    add_header Content-Security-Policy "default-src 'self' http: https: data: blob: 'unsafe-inline'" always;

    # Лимиты загрузки файлов
    client_max_body_size 100M;
    client_body_timeout 60s;
    client_header_timeout 60s;

    # Основное местоположение
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    # Обработка PHP
    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
        
        # Таймауты
        fastcgi_read_timeout 300;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
    }

    # Ограничение скорости API
    location /apis/ {
        limit_req zone=api burst=20 nodelay;
        try_files $uri $uri/ /index.php?$query_string;
    }

    # Ограничение скорости входа
    location ~ ^/(login|register) {
        limit_req zone=login burst=5 nodelay;
        try_files $uri $uri/ /index.php?$query_string;
    }

    # Кэширование статических файлов
    location ~* \.(jpg|jpeg|png|gif|ico|css|js|woff|woff2|ttf|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
        access_log off;
    }

    # Запретить доступ к чувствительным файлам
    location ~ /\.(ht|env|git) {
        deny all;
    }

    location ~ /(config|includes|vendor)/ {
        deny all;
    }

    # Security.txt
    location = /.well-known/security.txt {
        return 301 /security.txt;
    }
}
```

#### Включить сайт

```bash
# Включить сайт
sudo ln -s /etc/nginx/sites-available/rechain-dao /etc/nginx/sites-enabled/

# Удалить сайт по умолчанию
sudo rm /etc/nginx/sites-enabled/default

# Проверить конфигурацию
sudo nginx -t

# Перезапустить Nginx
sudo systemctl restart nginx
sudo systemctl enable nginx
```

### Конфигурация Apache (альтернатива)

#### Включить необходимые модули

```bash
# Включить необходимые модули
sudo a2enmod rewrite
sudo a2enmod headers
sudo a2enmod ssl
sudo a2enmod deflate
sudo a2enmod expires
```

#### Конфигурация виртуального хоста

```bash
# Создать виртуальный хост
sudo nano /etc/apache2/sites-available/rechain-dao.conf
```

```apache
<VirtualHost *:80>
    ServerName yourdomain.com
    ServerAlias www.yourdomain.com
    DocumentRoot /var/www/html

    # Заголовки безопасности
    Header always set X-Frame-Options "SAMEORIGIN"
    Header always set X-XSS-Protection "1; mode=block"
    Header always set X-Content-Type-Options "nosniff"
    Header always set Referrer-Policy "no-referrer-when-downgrade"

    # Лимиты загрузки файлов
    LimitRequestBody 104857600

    <Directory /var/www/html>
        AllowOverride All
        Require all granted
    </Directory>

    # Запретить доступ к чувствительным файлам
    <FilesMatch "\.(ht|env|git)">
        Require all denied
    </FilesMatch>

    <DirectoryMatch "(config|includes|vendor)">
        Require all denied
    </DirectoryMatch>

    # Логирование
    ErrorLog ${APACHE_LOG_DIR}/rechain-dao_error.log
    CustomLog ${APACHE_LOG_DIR}/rechain-dao_access.log combined
</VirtualHost>
```

```bash
# Включить сайт
sudo a2ensite rechain-dao
sudo a2dissite 000-default
sudo systemctl restart apache2
```

## Настройка SSL сертификата

### Let's Encrypt (бесплатный)

#### Установить Certbot

```bash
# Ubuntu
sudo apt install -y certbot python3-certbot-nginx

# CentOS
sudo dnf install -y certbot python3-certbot-nginx
```

#### Получить сертификат

```bash
# Получить сертификат
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com

# Тестировать обновление
sudo certbot renew --dry-run

# Настроить автоматическое обновление
sudo crontab -e
# Добавить: 0 12 * * * /usr/bin/certbot renew --quiet
```

### Коммерческий сертификат

#### Загрузить файлы сертификата

```bash
# Создать каталог SSL
sudo mkdir -p /etc/ssl/rechain-dao

# Загрузить файлы сертификата
sudo cp yourdomain.crt /etc/ssl/rechain-dao/
sudo cp yourdomain.key /etc/ssl/rechain-dao/
sudo cp ca-bundle.crt /etc/ssl/rechain-dao/

# Установить права доступа
sudo chmod 600 /etc/ssl/rechain-dao/*
sudo chown root:root /etc/ssl/rechain-dao/*
```

#### Обновить конфигурацию Nginx

```nginx
server {
    listen 443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;
    root /var/www/html;
    index index.php index.html;

    # Конфигурация SSL
    ssl_certificate /etc/ssl/rechain-dao/yourdomain.crt;
    ssl_certificate_key /etc/ssl/rechain-dao/yourdomain.key;
    ssl_trusted_certificate /etc/ssl/rechain-dao/ca-bundle.crt;

    # Настройки SSL
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384:DHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    ssl_session_timeout 10m;

    # HSTS
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;

    # Остальная конфигурация...
}

# Перенаправить HTTP на HTTPS
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    return 301 https://$server_name$request_uri;
}
```

## Развертывание приложения

### Клонировать и настроить приложение

```bash
# Клонировать репозиторий
cd /var/www/html
sudo -u www-data git clone https://github.com/REChain-Network-Solutions/DAO.git .

# Установить зависимости
sudo -u www-data composer install --no-dev --optimize-autoloader
sudo -u www-data npm install --production

# Установить права доступа
sudo chown -R www-data:www-data /var/www/html
sudo chmod -R 755 /var/www/html
sudo chmod -R 777 /var/www/html/content/uploads
sudo chmod -R 777 /var/www/html/content/backups
```

### Настройка базы данных

```bash
# Импортировать схему базы данных
mysql -u dao_user -p rechain_dao < /var/www/html/Extras/SQL/schema.sql

# Запустить миграции базы данных (если есть)
cd /var/www/html
sudo -u www-data php migrate.php
```

### Конфигурация

```bash
# Скопировать шаблон конфигурации
sudo -u www-data cp includes/config-example.php includes/config.php

# Редактировать конфигурацию
sudo -u www-data nano includes/config.php
```

```php
<?php
// Конфигурация базы данных
define('DB_NAME', 'rechain_dao');
define('DB_USER', 'dao_user');
define('DB_PASSWORD', 'secure_password_here');
define('DB_HOST', 'localhost');
define('DB_PORT', '3306');

// URL системы
define('SYS_URL', 'https://yourdomain.com');

// Настройки безопасности
define('URL_CHECK', 'true');
define('DEBUGGING', false);

// Ключ лицензии
define('LICENCE_KEY', 'your_license_key_here');

// Настройки кэширования
define('CACHE_ENABLED', true);
define('CACHE_DRIVER', 'redis'); // или 'file'
define('REDIS_HOST', '127.0.0.1');
define('REDIS_PORT', '6379');
define('REDIS_PASSWORD', 'your_redis_password');

// Настройки email
define('SMTP_HOST', 'smtp.gmail.com');
define('SMTP_PORT', '587');
define('SMTP_USERNAME', 'your-email@gmail.com');
define('SMTP_PASSWORD', 'your-app-password');
define('SMTP_ENCRYPTION', 'tls');

// Настройки загрузки файлов
define('UPLOAD_MAX_SIZE', '100M');
define('UPLOAD_ALLOWED_TYPES', 'jpg,jpeg,png,gif,pdf,doc,docx');

// Настройки безопасности
define('SESSION_LIFETIME', 1440);
define('CSRF_TOKEN_LIFETIME', 3600);
define('PASSWORD_MIN_LENGTH', 8);
```

### Конфигурация PHP-FPM

```bash
# Редактировать конфигурацию PHP-FPM
sudo nano /etc/php/8.3/fpm/pool.d/www.conf
```

```ini
[www]
user = www-data
group = www-data
listen = /var/run/php/php8.3-fpm.sock
listen.owner = www-data
listen.group = www-data
listen.mode = 0660

pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
pm.max_requests = 1000

; Настройки производительности
pm.process_idle_timeout = 10s
pm.max_requests = 1000

; Логирование
php_admin_value[error_log] = /var/log/php8.3-fpm.log
php_admin_flag[log_errors] = on
```

```bash
# Перезапустить PHP-FPM
sudo systemctl restart php8.3-fpm
```

## Мониторинг и логирование

### Конфигурация логов

#### Логи Nginx

```bash
# Настроить ротацию логов
sudo nano /etc/logrotate.d/nginx
```

```
/var/log/nginx/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 640 nginx adm
    sharedscripts
    postrotate
        if [ -f /var/run/nginx.pid ]; then
            kill -USR1 `cat /var/run/nginx.pid`
        fi
    endscript
}
```

#### Логи приложения

```bash
# Создать каталог логов
sudo mkdir -p /var/www/html/content/logs
sudo chown www-data:www-data /var/www/html/content/logs

# Настроить ротацию логов
sudo nano /etc/logrotate.d/rechain-dao
```

```
/var/www/html/content/logs/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 www-data www-data
    sharedscripts
    postrotate
        # Перезагрузить приложение если нужно
    endscript
}
```

### Настройка мониторинга

#### Установить инструменты мониторинга

```bash
# Установить htop, iotop, nethogs
sudo apt install -y htop iotop nethogs

# Установить скрипты мониторинга
sudo mkdir -p /opt/monitoring
```

#### Скрипт мониторинга системы

```bash
# Создать скрипт мониторинга
sudo nano /opt/monitoring/system-monitor.sh
```

```bash
#!/bin/bash

# Скрипт мониторинга системы
LOG_FILE="/var/log/system-monitor.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Проверить использование диска
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo "$DATE ПРЕДУПРЕЖДЕНИЕ: Использование диска ${DISK_USAGE}%" >> $LOG_FILE
fi

# Проверить использование памяти
MEMORY_USAGE=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}')
if [ $MEMORY_USAGE -gt 90 ]; then
    echo "$DATE ПРЕДУПРЕЖДЕНИЕ: Использование памяти ${MEMORY_USAGE}%" >> $LOG_FILE
fi

# Проверить статус MySQL
if ! systemctl is-active --quiet mysql; then
    echo "$DATE ОШИБКА: MySQL не запущен" >> $LOG_FILE
fi

# Проверить статус Nginx
if ! systemctl is-active --quiet nginx; then
    echo "$DATE ОШИБКА: Nginx не запущен" >> $LOG_FILE
fi

# Проверить статус PHP-FPM
if ! systemctl is-active --quiet php8.3-fpm; then
    echo "$DATE ОШИБКА: PHP-FPM не запущен" >> $LOG_FILE
fi
```

```bash
# Сделать исполняемым
sudo chmod +x /opt/monitoring/system-monitor.sh

# Добавить в crontab
sudo crontab -e
# Добавить: */5 * * * * /opt/monitoring/system-monitor.sh
```

### Мониторинг приложения

#### Endpoint проверки здоровья

```php
// Создать endpoint проверки здоровья
sudo nano /var/www/html/health.php
```

```php
<?php
header('Content-Type: application/json');

$health = [
    'status' => 'ok',
    'timestamp' => date('Y-m-d H:i:s'),
    'checks' => []
];

// Проверить подключение к базе данных
try {
    $db = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT);
    if ($db->connect_error) {
        throw new Exception('Ошибка подключения к базе данных');
    }
    $health['checks']['database'] = 'ok';
} catch (Exception $e) {
    $health['checks']['database'] = 'ошибка: ' . $e->getMessage();
    $health['status'] = 'error';
}

// Проверить подключение к Redis (если включен)
if (defined('CACHE_ENABLED') && CACHE_ENABLED && CACHE_DRIVER === 'redis') {
    try {
        $redis = new Redis();
        $redis->connect(REDIS_HOST, REDIS_PORT);
        if (defined('REDIS_PASSWORD')) {
            $redis->auth(REDIS_PASSWORD);
        }
        $health['checks']['redis'] = 'ok';
    } catch (Exception $e) {
        $health['checks']['redis'] = 'ошибка: ' . $e->getMessage();
        $health['status'] = 'error';
    }
}

// Проверить свободное место на диске
$disk_free = disk_free_space('/');
$disk_total = disk_total_space('/');
$disk_usage = (($disk_total - $disk_free) / $disk_total) * 100;
$health['checks']['disk_usage'] = round($disk_usage, 2) . '%';

if ($disk_usage > 90) {
    $health['status'] = 'warning';
}

echo json_encode($health, JSON_PRETTY_PRINT);
?>
```

## Стратегия резервного копирования

### Резервное копирование базы данных

#### Автоматическое резервное копирование базы данных

```bash
# Создать скрипт резервного копирования
sudo nano /opt/backup/db-backup.sh
```

```bash
#!/bin/bash

# Скрипт резервного копирования базы данных
BACKUP_DIR="/opt/backups/database"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="rechain_dao"
DB_USER="dao_user"
DB_PASS="secure_password_here"

# Создать каталог резервного копирования
mkdir -p $BACKUP_DIR

# Создать резервную копию
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/db_backup_$DATE.sql

# Сжать резервную копию
gzip $BACKUP_DIR/db_backup_$DATE.sql

# Удалить старые резервные копии (хранить 30 дней)
find $BACKUP_DIR -name "db_backup_*.sql.gz" -mtime +30 -delete

# Загрузить в облачное хранилище (опционально)
# aws s3 cp $BACKUP_DIR/db_backup_$DATE.sql.gz s3://your-backup-bucket/
```

```bash
# Сделать исполняемым
sudo chmod +x /opt/backup/db-backup.sh

# Добавить в crontab (ежедневно в 2:00)
sudo crontab -e
# Добавить: 0 2 * * * /opt/backup/db-backup.sh
```

### Резервное копирование файлов

#### Резервное копирование файлов приложения

```bash
# Создать скрипт резервного копирования файлов
sudo nano /opt/backup/files-backup.sh
```

```bash
#!/bin/bash

# Скрипт резервного копирования файлов
BACKUP_DIR="/opt/backups/files"
DATE=$(date +%Y%m%d_%H%M%S)
APP_DIR="/var/www/html"

# Создать каталог резервного копирования
mkdir -p $BACKUP_DIR

# Создать резервную копию (исключить кэш и логи)
tar -czf $BACKUP_DIR/files_backup_$DATE.tar.gz \
    --exclude='content/cache/*' \
    --exclude='content/logs/*' \
    --exclude='node_modules/*' \
    --exclude='vendor/*' \
    -C $APP_DIR .

# Удалить старые резервные копии (хранить 7 дней)
find $BACKUP_DIR -name "files_backup_*.tar.gz" -mtime +7 -delete
```

```bash
# Сделать исполняемым
sudo chmod +x /opt/backup/files-backup.sh

# Добавить в crontab (ежедневно в 3:00)
sudo crontab -e
# Добавить: 0 3 * * * /opt/backup/files-backup.sh
```

### Проверка резервного копирования

```bash
# Создать скрипт проверки резервного копирования
sudo nano /opt/backup/verify-backup.sh
```

```bash
#!/bin/bash

# Скрипт проверки резервного копирования
BACKUP_DIR="/opt/backups"
LOG_FILE="/var/log/backup-verification.log"

echo "$(date): Начало проверки резервного копирования" >> $LOG_FILE

# Проверить резервную копию базы данных
LATEST_DB_BACKUP=$(ls -t $BACKUP_DIR/database/db_backup_*.sql.gz | head -1)
if [ -f "$LATEST_DB_BACKUP" ]; then
    # Проверить, можно ли восстановить резервную копию
    gunzip -t "$LATEST_DB_BACKUP"
    if [ $? -eq 0 ]; then
        echo "$(date): Проверка резервной копии базы данных прошла успешно" >> $LOG_FILE
    else
        echo "$(date): ОШИБКА: Проверка резервной копии базы данных не удалась" >> $LOG_FILE
    fi
else
    echo "$(date): ОШИБКА: Резервная копия базы данных не найдена" >> $LOG_FILE
fi

# Проверить резервную копию файлов
LATEST_FILE_BACKUP=$(ls -t $BACKUP_DIR/files/files_backup_*.tar.gz | head -1)
if [ -f "$LATEST_FILE_BACKUP" ]; then
    # Проверить, можно ли извлечь резервную копию
    tar -tzf "$LATEST_FILE_BACKUP" > /dev/null
    if [ $? -eq 0 ]; then
        echo "$(date): Проверка резервной копии файлов прошла успешно" >> $LOG_FILE
    else
        echo "$(date): ОШИБКА: Проверка резервной копии файлов не удалась" >> $LOG_FILE
    fi
else
    echo "$(date): ОШИБКА: Резервная копия файлов не найдена" >> $LOG_FILE
fi
```

## Масштабирование и производительность

### Горизонтальное масштабирование

#### Конфигурация балансировщика нагрузки

```nginx
# Конфигурация балансировщика нагрузки
upstream backend {
    server 192.168.1.10:80 weight=3;
    server 192.168.1.11:80 weight=3;
    server 192.168.1.12:80 weight=2;
    
    # Проверка здоровья
    keepalive 32;
}

server {
    listen 80;
    server_name yourdomain.com;
    
    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    # Endpoint проверки здоровья
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
```

### Масштабирование базы данных

#### Реплики чтения

```sql
-- Конфигурация основной базы данных
-- В /etc/mysql/mysql.conf.d/mysqld.cnf
[mysqld]
server-id = 1
log-bin = mysql-bin
binlog-format = ROW

-- Создать пользователя репликации
CREATE USER 'replica_user'@'%' IDENTIFIED BY 'replica_password';
GRANT REPLICATION SLAVE ON *.* TO 'replica_user'@'%';
FLUSH PRIVILEGES;

-- Показать статус мастера
SHOW MASTER STATUS;
```

```sql
-- Конфигурация базы данных-слейва
-- В /etc/mysql/mysql.conf.d/mysqld.cnf
[mysqld]
server-id = 2
relay-log = mysql-relay-bin
read-only = 1

-- Настроить репликацию
CHANGE MASTER TO
    MASTER_HOST='192.168.1.10',
    MASTER_USER='replica_user',
    MASTER_PASSWORD='replica_password',
    MASTER_LOG_FILE='mysql-bin.000001',
    MASTER_LOG_POS=154;

-- Запустить репликацию
START SLAVE;
SHOW SLAVE STATUS\G
```

### Стратегия кэширования

#### Конфигурация Redis

```bash
# Конфигурация Redis для продакшена
sudo nano /etc/redis/redis.conf
```

```ini
# Настройки памяти
maxmemory 1gb
maxmemory-policy allkeys-lru

# Персистентность
save 900 1
save 300 10
save 60 10000

# Безопасность
requirepass your_redis_password
rename-command FLUSHDB ""
rename-command FLUSHALL ""
```

#### Кэширование приложения

```php
// Конфигурация кэширования в config.php
define('CACHE_ENABLED', true);
define('CACHE_DRIVER', 'redis');
define('CACHE_TTL', 3600); // 1 час

// Подключение к Redis
$redis = new Redis();
$redis->connect(REDIS_HOST, REDIS_PORT);
$redis->auth(REDIS_PASSWORD);

// Функции кэширования
function cache_get($key) {
    global $redis;
    $data = $redis->get($key);
    return $data ? unserialize($data) : false;
}

function cache_set($key, $data, $ttl = 3600) {
    global $redis;
    return $redis->setex($key, $ttl, serialize($data));
}
```

## Усиление безопасности

### Усиление сервера

#### Конфигурация файрвола

```bash
# Установить UFW
sudo apt install -y ufw

# Настроить файрвол
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

#### Усиление SSH

```bash
# Редактировать конфигурацию SSH
sudo nano /etc/ssh/sshd_config
```

```ini
# Отключить вход root
PermitRootLogin no

# Отключить аутентификацию по паролю
PasswordAuthentication no
PubkeyAuthentication yes

# Изменить порт по умолчанию
Port 2222

# Ограничить пользователей
AllowUsers deploy

# Отключить пустые пароли
PermitEmptyPasswords no

# Отключить переадресацию X11
X11Forwarding no
```

```bash
# Перезапустить SSH
sudo systemctl restart ssh
```

### Безопасность приложения

#### Безопасность PHP

```ini
; Настройки безопасности PHP в php.ini
expose_php = Off
allow_url_fopen = Off
allow_url_include = Off
disable_functions = exec,passthru,shell_exec,system,proc_open,popen
upload_max_filesize = 10M
post_max_size = 10M
max_execution_time = 30
memory_limit = 128M
```

#### Права доступа к файлам

```bash
# Установить безопасные права доступа к файлам
sudo find /var/www/html -type f -exec chmod 644 {} \;
sudo find /var/www/html -type d -exec chmod 755 {} \;
sudo chmod 600 /var/www/html/includes/config.php
sudo chmod -R 777 /var/www/html/content/uploads
```

### Мониторинг безопасности

#### Конфигурация Fail2Ban

```bash
# Установить Fail2Ban
sudo apt install -y fail2ban

# Настроить Fail2Ban
sudo nano /etc/fail2ban/jail.local
```

```ini
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = 2222
filter = sshd
logpath = /var/log/auth.log

[nginx-http-auth]
enabled = true
filter = nginx-http-auth
logpath = /var/log/nginx/error.log

[nginx-limit-req]
enabled = true
filter = nginx-limit-req
logpath = /var/log/nginx/error.log
maxretry = 10
```

```bash
# Запустить Fail2Ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban
```

## Устранение неполадок

### Частые проблемы

#### Высокое использование памяти

```bash
# Проверить использование памяти
free -h
ps aux --sort=-%mem | head -10

# Проверить процессы PHP-FPM
ps aux | grep php-fpm | wc -l

# Оптимизировать PHP-FPM
sudo nano /etc/php/8.3/fpm/pool.d/www.conf
# Уменьшить pm.max_children
```

#### Проблемы подключения к базе данных

```bash
# Проверить статус MySQL
sudo systemctl status mysql
sudo systemctl restart mysql

# Проверить соединения
mysql -u root -p -e "SHOW PROCESSLIST;"

# Проверить логи MySQL
sudo tail -f /var/log/mysql/error.log
```

#### Проблемы с SSL сертификатом

```bash
# Проверить валидность сертификата
openssl x509 -in /etc/ssl/rechain-dao/yourdomain.crt -text -noout

# Тестировать конфигурацию SSL
sslscan yourdomain.com

# Обновить сертификат Let's Encrypt
sudo certbot renew --dry-run
```

### Мониторинг производительности

#### Метрики сервера

```bash
# Установить инструменты мониторинга
sudo apt install -y htop iotop nethogs

# Мониторить в реальном времени
htop
iotop
nethogs
```

#### Метрики приложения

```bash
# Проверить логи приложения
sudo tail -f /var/www/html/content/logs/error.log

# Проверить логи веб-сервера
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Проверить логи PHP-FPM
sudo tail -f /var/log/php8.3-fpm.log
```

---

*Это руководство по развертыванию предоставляет всесторонние инструкции для развертывания REChain DAO в продакшене. Для дополнительной поддержки или расширенных конфигураций, пожалуйста, обратитесь к руководству по устранению неполадок или свяжитесь с командой разработки.*
