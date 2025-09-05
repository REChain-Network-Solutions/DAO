# REChain DAO - Руководство по установке

## Предварительные требования

### Системные требования

**Минимальные требования:**
- PHP 8.2 или выше
- MySQL 5.7+ или MariaDB 10.3+
- Apache 2.4+ или Nginx 1.18+
- 2 ГБ ОЗУ минимум
- 10 ГБ свободного места на диске

**Рекомендуемые требования:**
- PHP 8.3+
- MySQL 8.0+ или MariaDB 10.6+
- Apache 2.4+ с mod_rewrite или Nginx 1.20+
- 4 ГБ ОЗУ или больше
- 50 ГБ+ свободного места на диске
- SSD накопитель

### Необходимые расширения PHP

Убедитесь, что следующие расширения PHP установлены и включены:

```bash
# Основные расширения
php-mysqli
php-curl
php-mbstring
php-gd
php-fileinfo
php-zip
php-json
php-xml
php-intl

# Опциональные, но рекомендуемые
php-opcache
php-redis
php-memcached
php-imagick
```

### Конфигурация веб-сервера

#### Конфигурация Apache

Создайте или обновите файл `.htaccess`:

```apache
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule ^(.*)$ index.php [QSA,L]

# Заголовки безопасности
Header always set X-Content-Type-Options nosniff
Header always set X-Frame-Options DENY
Header always set X-XSS-Protection "1; mode=block"
Header always set Referrer-Policy "strict-origin-when-cross-origin"

# Лимиты загрузки файлов
php_value upload_max_filesize 100M
php_value post_max_size 100M
php_value max_execution_time 300
php_value memory_limit 256M
```

#### Конфигурация Nginx

```nginx
server {
    listen 80;
    server_name your-domain.com;
    root /var/www/html/dao;
    index index.php;

    # Заголовки безопасности
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;
    add_header X-XSS-Protection "1; mode=block";
    add_header Referrer-Policy "strict-origin-when-cross-origin";

    # Лимиты загрузки файлов
    client_max_body_size 100M;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include fastcgi_params;
    }

    # Запретить доступ к чувствительным файлам
    location ~ /\.(ht|env) {
        deny all;
    }
}
```

## Методы установки

### Метод 1: Ручная установка

#### Шаг 1: Загрузка и извлечение

```bash
# Клонировать репозиторий
git clone https://github.com/REChain-Network-Solutions/DAO.git
cd DAO

# Или скачать и извлечь ZIP
wget https://github.com/REChain-Network-Solutions/DAO/archive/main.zip
unzip main.zip
cd DAO-main
```

#### Шаг 2: Установка прав доступа

```bash
# Установить правильные права доступа
chmod -R 755 .
chmod -R 777 content/uploads/
chmod -R 777 content/backups/
chmod -R 777 includes/config.php

# Установить владельца (замените www-data на пользователя веб-сервера)
chown -R www-data:www-data .
```

#### Шаг 3: Установка зависимостей

```bash
# Установить зависимости PHP
composer install --no-dev --optimize-autoloader

# Установить зависимости Node.js (если необходимо)
npm install --production
```

#### Шаг 4: Настройка базы данных

1. Создать базу данных MySQL:
```sql
CREATE DATABASE rechain_dao CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'dao_user'@'localhost' IDENTIFIED BY 'secure_password';
GRANT ALL PRIVILEGES ON rechain_dao.* TO 'dao_user'@'localhost';
FLUSH PRIVILEGES;
```

2. Импортировать схему базы данных:
```bash
mysql -u dao_user -p rechain_dao < Extras/SQL/schema.sql
```

#### Шаг 5: Конфигурация

1. Скопировать шаблон конфигурации:
```bash
cp includes/config-example.php includes/config.php
```

2. Отредактировать `includes/config.php` с вашими настройками:
```php
<?php
// Конфигурация базы данных
define('DB_NAME', 'rechain_dao');
define('DB_USER', 'dao_user');
define('DB_PASSWORD', 'secure_password');
define('DB_HOST', 'localhost');
define('DB_PORT', '3306');

// URL системы
define('SYS_URL', 'https://your-domain.com');

// Настройки безопасности
define('URL_CHECK', 'true');
define('DEBUGGING', false);

// Ключ лицензии (если применимо)
define('LICENCE_KEY', 'your_license_key');
```

#### Шаг 6: Запуск установщика

1. Перейти на `http://your-domain.com/install.php`
2. Следовать мастеру установки
3. Завершить процесс настройки

### Метод 2: Установка через Docker

#### Шаг 1: Клонирование репозитория

```bash
git clone https://github.com/REChain-Network-Solutions/DAO.git
cd DAO
```

#### Шаг 2: Конфигурация окружения

Создать файл `.env`:
```env
# База данных
DB_HOST=mysql
DB_PORT=3306
DB_NAME=rechain_dao
DB_USER=dao_user
DB_PASSWORD=secure_password

# Приложение
SYS_URL=http://localhost:8080
DEBUGGING=false
LICENCE_KEY=your_license_key

# Redis (опционально)
REDIS_HOST=redis
REDIS_PORT=6379
```

#### Шаг 3: Запуск сервисов

```bash
# Запустить все сервисы
docker-compose up -d

# Проверить логи
docker-compose logs -f
```

#### Шаг 4: Инициализация базы данных

```bash
# Запустить миграции базы данных
docker-compose exec web php install.php
```

### Метод 3: Облачная установка

#### Установка на AWS EC2

1. Запустить экземпляр EC2 (Ubuntu 22.04 LTS)
2. Установить стек LAMP:
```bash
sudo apt update
sudo apt install apache2 mysql-server php8.3 php8.3-mysql php8.3-curl php8.3-mbstring php8.3-gd php8.3-zip composer
```

3. Следовать шагам ручной установки

#### DigitalOcean Droplet

1. Создать дроплет со стеком LAMP
2. Следовать шагам ручной установки
3. Настроить SSL с Let's Encrypt

## Конфигурация после установки

### 1. Настройка SSL сертификата

#### Использование Let's Encrypt (Certbot)

```bash
# Установить Certbot
sudo apt install certbot python3-certbot-apache

# Получить сертификат
sudo certbot --apache -d your-domain.com

# Автоматическое обновление
sudo crontab -e
# Добавить: 0 12 * * * /usr/bin/certbot renew --quiet
```

### 2. Оптимизация базы данных

```sql
-- Оптимизировать настройки MySQL
SET GLOBAL innodb_buffer_pool_size = 1G;
SET GLOBAL max_connections = 200;
SET GLOBAL query_cache_size = 64M;
```

### 3. Конфигурация PHP

Отредактировать `/etc/php/8.3/apache2/php.ini`:

```ini
# Настройки производительности
memory_limit = 256M
max_execution_time = 300
max_input_time = 300
upload_max_filesize = 100M
post_max_size = 100M

# Настройки безопасности
expose_php = Off
allow_url_fopen = Off
allow_url_include = Off

# Настройки OPcache
opcache.enable = 1
opcache.memory_consumption = 128
opcache.max_accelerated_files = 4000
opcache.revalidate_freq = 2
```

### 4. Настройка Cron задач

```bash
# Редактировать crontab
crontab -e

# Добавить эти задачи
# Очистка временных файлов каждый час
0 * * * * find /var/www/html/dao/content/uploads/temp -type f -mtime +1 -delete

# Резервное копирование базы данных ежедневно в 2:00
0 2 * * * mysqldump -u dao_user -p'secure_password' rechain_dao > /var/backups/dao_$(date +\%Y\%m\%d).sql

# Очистка кэша каждые 6 часов
0 */6 * * * rm -rf /var/www/html/dao/content/cache/*
```

## Проверка и тестирование

### 1. Проверка системы

Посетите `http://your-domain.com/admin` и проверьте:
- Подключение к базе данных
- Права доступа к файлам
- Расширения PHP
- Системные требования

### 2. Тестирование производительности

```bash
# Тест с Apache Bench
ab -n 1000 -c 10 http://your-domain.com/

# Тест с curl
curl -I http://your-domain.com/
```

### 3. Тестирование безопасности

```bash
# Проверить на распространённые уязвимости
nmap -sV -sC your-domain.com

# Тестировать конфигурацию SSL
sslscan your-domain.com
```

## Устранение неполадок

### Частые проблемы

#### 1. Ошибка подключения к базе данных

**Ошибка**: `Could not connect to database`

**Решение**:
- Проверить учётные данные базы данных в `config.php`
- Убедиться, что служба MySQL запущена
- Проверить настройки файрвола

#### 2. Ошибки прав доступа к файлам

**Ошибка**: `Permission denied`

**Решение**:
```bash
chmod -R 755 .
chmod -R 777 content/uploads/
chown -R www-data:www-data .
```

#### 3. Превышен лимит памяти

**Ошибка**: `Fatal error: Allowed memory size exhausted`

**Решение**:
- Увеличить `memory_limit` в `php.ini`
- Оптимизировать запросы к базе данных
- Включить OPcache

#### 4. Ошибка 500 Internal Server Error

**Решение**:
- Проверить логи ошибок Apache/Nginx
- Проверить конфигурацию `.htaccess`
- Проверить логи ошибок PHP

### Файлы логов

**Логи Apache**:
- Лог ошибок: `/var/log/apache2/error.log`
- Лог доступа: `/var/log/apache2/access.log`

**Логи Nginx**:
- Лог ошибок: `/var/log/nginx/error.log`
- Лог доступа: `/var/log/nginx/access.log`

**Логи PHP**:
- Лог ошибок: `/var/log/php8.3/error.log`

**Логи приложения**:
- Системный лог: `content/logs/system.log`
- Лог ошибок: `content/logs/error.log`

## Обслуживание

### Регулярные задачи обслуживания

1. **Обслуживание базы данных**:
   - Регулярные резервные копии
   - Оптимизация запросов
   - Обслуживание индексов

2. **Обслуживание файловой системы**:
   - Очистка временных файлов
   - Мониторинг использования диска
   - Обновление прав доступа к файлам

3. **Обновления безопасности**:
   - Обновление версии PHP
   - Обновление зависимостей
   - Патчи безопасности

4. **Мониторинг производительности**:
   - Мониторинг ресурсов сервера
   - Анализ медленных запросов
   - Оптимизация кэширования

### Стратегия резервного копирования

```bash
#!/bin/bash
# Скрипт резервного копирования
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/dao"

# Создать каталог резервного копирования
mkdir -p $BACKUP_DIR

# Резервное копирование базы данных
mysqldump -u dao_user -p'secure_password' rechain_dao > $BACKUP_DIR/db_$DATE.sql

# Резервное копирование файлов
tar -czf $BACKUP_DIR/files_$DATE.tar.gz /var/www/html/dao

# Очистка старых резервных копий (хранить 30 дней)
find $BACKUP_DIR -name "*.sql" -mtime +30 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete
```

## Поддержка

Для дополнительной поддержки:

- **Документация**: Проверьте каталог `/docs`
- **Проблемы**: Сообщите в GitHub Issues
- **Сообщество**: Присоединяйтесь к нашему Discord серверу
- **Email**: support@rechain.network

---

*Это руководство по установке охватывает полный процесс настройки REChain DAO. Для расширенных опций конфигурации обратитесь к документации конкретных компонентов.*
