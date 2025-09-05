# Руководство системного администратора

## Обзор

Это комплексное руководство предоставляет системным администраторам важную информацию для управления, обслуживания и устранения неполадок платформы REChain DAO.

## Содержание

1. [Обзор системы](#обзор-системы)
2. [Ежедневные административные задачи](#ежедневные-административные-задачи)
3. [Управление пользователями](#управление-пользователями)
4. [Управление контентом](#управление-контентом)
5. [Мониторинг системы](#мониторинг-системы)
6. [Резервное копирование и восстановление](#резервное-копирование-и-восстановление)
7. [Управление безопасностью](#управление-безопасностью)
8. [Оптимизация производительности](#оптимизация-производительности)
9. [Устранение неполадок](#устранение-неполадок)
10. [Процедуры обслуживания](#процедуры-обслуживания)
11. [Процедуры экстренного реагирования](#процедуры-экстренного-реагирования)
12. [Лучшие практики](#лучшие-практики)

## Обзор системы

### Компоненты архитектуры

Платформа REChain DAO состоит из нескольких ключевых компонентов:

- **Веб-сервер**: Apache/Nginx с PHP 8.2+
- **База данных**: MySQL 8.0+ с движком InnoDB
- **Кэш**: Redis для кэширования сессий и данных
- **Файловое хранилище**: Локальная файловая система с поддержкой CDN
- **Фоновые задачи**: Cron задачи для запланированных операций
- **Мониторинг**: Инструменты мониторинга системы и приложения

### Системные требования

#### Минимальные требования
- **CPU**: 2 ядра, 2.4GHz
- **RAM**: 4GB
- **Хранилище**: 50GB SSD
- **Сеть**: 100Mbps соединение

#### Рекомендуемые требования
- **CPU**: 4+ ядра, 3.0GHz
- **RAM**: 8GB+
- **Хранилище**: 200GB+ SSD
- **Сеть**: 1Gbps соединение

### Структура директорий

```
/var/www/rechain-dao/
├── api/                    # API endpoints
├── assets/                 # Статические ресурсы
├── content/               # Пользовательский контент
├── includes/              # Основные системные файлы
├── modules/               # Модули функций
├── uploads/               # Загрузки пользователей
├── logs/                  # Системные логи
├── backups/               # Файлы резервных копий
└── config/                # Файлы конфигурации
```

## Ежедневные административные задачи

### Утренний чек-лист

#### Проверка состояния системы
```bash
# Проверить системные ресурсы
top -bn1 | head -20
df -h
free -h
netstat -tuln | grep :80
netstat -tuln | grep :443
netstat -tuln | grep :3306
```

#### Статус сервисов
```bash
# Проверить критические сервисы
systemctl status apache2
systemctl status mysql
systemctl status redis
systemctl status cron
```

#### Обзор логов
```bash
# Обзор логов ошибок
tail -100 /var/log/apache2/error.log
tail -100 /var/log/mysql/error.log
tail -100 /var/www/rechain-dao/logs/error.log
```

### Мониторинг активности пользователей

#### Активные пользователи
```sql
-- Проверить активных пользователей
SELECT 
    user_id,
    user_name,
    user_email,
    user_last_seen,
    user_ip
FROM users 
WHERE user_last_seen > DATE_SUB(NOW(), INTERVAL 1 HOUR)
ORDER BY user_last_seen DESC;
```

#### Новые регистрации
```sql
-- Проверить новые регистрации
SELECT 
    user_id,
    user_name,
    user_email,
    user_registered,
    user_verified
FROM users 
WHERE user_registered > DATE_SUB(NOW(), INTERVAL 24 HOUR)
ORDER BY user_registered DESC;
```

### Модерация контента

#### Ожидающая модерации
```sql
-- Проверить контент, ожидающий модерации
SELECT 
    p.post_id,
    p.post_text,
    u.user_name,
    p.post_created
FROM posts p
JOIN users u ON p.user_id = u.user_id
WHERE p.post_status = 'pending'
ORDER BY p.post_created ASC;
```

#### Сообщенный контент
```sql
-- Проверить сообщенный контент
SELECT 
    r.report_id,
    r.report_type,
    r.report_reason,
    u.user_name as reporter,
    r.report_created
FROM reports r
JOIN users u ON r.report_user_id = u.user_id
WHERE r.report_status = 'pending'
ORDER BY r.report_created ASC;
```

## Управление пользователями

### Администрирование пользователей

#### Поиск и фильтрация пользователей
```sql
-- Поиск пользователей по различным критериям
SELECT 
    user_id,
    user_name,
    user_email,
    user_firstname,
    user_lastname,
    user_registered,
    user_verified,
    user_banned,
    user_admin
FROM users 
WHERE user_name LIKE '%search_term%'
   OR user_email LIKE '%search_term%'
   OR user_firstname LIKE '%search_term%'
   OR user_lastname LIKE '%search_term%'
ORDER BY user_registered DESC;
```

#### Управление статусом пользователей
```php
// Заблокировать пользователя
function ban_user($user_id, $reason) {
    global $db;
    
    $stmt = $db->prepare("UPDATE users SET user_banned = 1, ban_reason = ?, ban_date = NOW() WHERE user_id = ?");
    $stmt->bind_param("si", $reason, $user_id);
    $stmt->execute();
    
    // Логировать действие
    log_admin_action('BAN_USER', $user_id, $reason);
}

// Разблокировать пользователя
function unban_user($user_id) {
    global $db;
    
    $stmt = $db->prepare("UPDATE users SET user_banned = 0, ban_reason = NULL, ban_date = NULL WHERE user_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    
    // Логировать действие
    log_admin_action('UNBAN_USER', $user_id, 'User unbanned');
}
```

#### Управление ролями
```php
// Назначить роль администратора
function assign_admin_role($user_id) {
    global $db;
    
    $stmt = $db->prepare("UPDATE users SET user_admin = 1 WHERE user_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    
    // Логировать действие
    log_admin_action('ASSIGN_ADMIN', $user_id, 'Admin role assigned');
}

// Удалить роль администратора
function remove_admin_role($user_id) {
    global $db;
    
    $stmt = $db->prepare("UPDATE users SET user_admin = 0 WHERE user_id = ?");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    
    // Логировать действие
    log_admin_action('REMOVE_ADMIN', $user_id, 'Admin role removed');
}
```

### Поддержка пользователей

#### Управление тикетами поддержки
```sql
-- Проверить ожидающие тикеты поддержки
SELECT 
    t.ticket_id,
    t.ticket_subject,
    t.ticket_priority,
    u.user_name,
    t.ticket_created,
    t.ticket_status
FROM support_tickets t
JOIN users u ON t.user_id = u.user_id
WHERE t.ticket_status = 'open'
ORDER BY t.ticket_priority DESC, t.ticket_created ASC;
```

#### Коммуникация с пользователями
```php
// Отправить системное сообщение пользователю
function send_system_message($user_id, $subject, $message) {
    global $db;
    
    $stmt = $db->prepare("INSERT INTO system_messages (user_id, message_subject, message_content, message_created) VALUES (?, ?, ?, NOW())");
    $stmt->bind_param("iss", $user_id, $subject, $message);
    $stmt->execute();
    
    // Отправить email уведомление
    send_email_notification($user_id, $subject, $message);
}
```

## Управление контентом

### Модерация контента

#### Модерация постов
```php
// Одобрить пост
function approve_post($post_id) {
    global $db;
    
    $stmt = $db->prepare("UPDATE posts SET post_status = 'approved', post_approved_by = ?, post_approved_date = NOW() WHERE post_id = ?");
    $stmt->bind_param("ii", $_SESSION['user_id'], $post_id);
    $stmt->execute();
    
    // Логировать действие
    log_admin_action('APPROVE_POST', $post_id, 'Post approved');
}

// Отклонить пост
function reject_post($post_id, $reason) {
    global $db;
    
    $stmt = $db->prepare("UPDATE posts SET post_status = 'rejected', post_rejection_reason = ?, post_rejected_by = ?, post_rejected_date = NOW() WHERE post_id = ?");
    $stmt->bind_param("sii", $reason, $_SESSION['user_id'], $post_id);
    $stmt->execute();
    
    // Логировать действие
    log_admin_action('REJECT_POST', $post_id, $reason);
}
```

#### Модерация комментариев
```php
// Модерировать комментарий
function moderate_comment($comment_id, $action, $reason = '') {
    global $db;
    
    if ($action === 'approve') {
        $stmt = $db->prepare("UPDATE comments SET comment_status = 'approved' WHERE comment_id = ?");
        $stmt->bind_param("i", $comment_id);
    } else {
        $stmt = $db->prepare("UPDATE comments SET comment_status = 'rejected', comment_rejection_reason = ? WHERE comment_id = ?");
        $stmt->bind_param("si", $reason, $comment_id);
    }
    
    $stmt->execute();
    
    // Логировать действие
    log_admin_action('MODERATE_COMMENT', $comment_id, $action . ': ' . $reason);
}
```

### Статистика контента

#### Обзор контента
```sql
-- Статистика контента
SELECT 
    'Posts' as content_type,
    COUNT(*) as total_count,
    SUM(CASE WHEN post_status = 'approved' THEN 1 ELSE 0 END) as approved,
    SUM(CASE WHEN post_status = 'pending' THEN 1 ELSE 0 END) as pending,
    SUM(CASE WHEN post_status = 'rejected' THEN 1 ELSE 0 END) as rejected
FROM posts
UNION ALL
SELECT 
    'Comments' as content_type,
    COUNT(*) as total_count,
    SUM(CASE WHEN comment_status = 'approved' THEN 1 ELSE 0 END) as approved,
    SUM(CASE WHEN comment_status = 'pending' THEN 1 ELSE 0 END) as pending,
    SUM(CASE WHEN comment_status = 'rejected' THEN 1 ELSE 0 END) as rejected
FROM comments;
```

#### Популярный контент
```sql
-- Самые популярные посты
SELECT 
    p.post_id,
    p.post_text,
    u.user_name,
    p.post_likes,
    p.post_comments,
    p.post_shares,
    p.post_views
FROM posts p
JOIN users u ON p.user_id = u.user_id
WHERE p.post_status = 'approved'
ORDER BY (p.post_likes + p.post_comments + p.post_shares + p.post_views) DESC
LIMIT 20;
```

## Мониторинг системы

### Мониторинг производительности

#### Системные ресурсы
```bash
# Использование CPU и памяти
htop
iostat -x 1
vmstat 1

# Использование диска
df -h
du -sh /var/www/rechain-dao/*
du -sh /var/lib/mysql/*

# Использование сети
iftop
netstat -i
```

#### Производительность базы данных
```sql
-- Запросы производительности базы данных
SHOW PROCESSLIST;
SHOW STATUS LIKE 'Threads_connected';
SHOW STATUS LIKE 'Max_used_connections';
SHOW STATUS LIKE 'Slow_queries';
SHOW STATUS LIKE 'Questions';
SHOW STATUS LIKE 'Uptime';

-- Проверить медленные запросы
SELECT 
    query_time,
    lock_time,
    rows_sent,
    rows_examined,
    sql_text
FROM mysql.slow_log 
ORDER BY query_time DESC 
LIMIT 10;
```

#### Производительность приложения
```php
// Мониторинг производительности
class PerformanceMonitor {
    public function log_page_load_time($page, $load_time) {
        $log_entry = [
            'timestamp' => date('Y-m-d H:i:s'),
            'page' => $page,
            'load_time' => $load_time,
            'memory_usage' => memory_get_usage(true),
            'peak_memory' => memory_get_peak_usage(true)
        ];
        
        error_log(json_encode($log_entry));
    }
    
    public function check_slow_queries() {
        $slow_queries = $this->get_slow_queries();
        if (count($slow_queries) > 10) {
            $this->send_alert('HIGH_SLOW_QUERIES', count($slow_queries));
        }
    }
}
```

### Мониторинг ошибок

#### Анализ логов ошибок
```bash
# Анализ логов ошибок
grep "ERROR" /var/log/apache2/error.log | tail -50
grep "FATAL" /var/log/mysql/error.log | tail -20
grep "Exception" /var/www/rechain-dao/logs/error.log | tail -50

# Подсчет ошибок по типам
grep "ERROR" /var/log/apache2/error.log | cut -d' ' -f4 | sort | uniq -c | sort -nr
```

#### Отслеживание ошибок приложения
```php
// Отслеживание ошибок
class ErrorTracker {
    public function track_error($error, $context = []) {
        $error_entry = [
            'timestamp' => date('Y-m-d H:i:s'),
            'error' => $error,
            'context' => $context,
            'user_id' => $_SESSION['user_id'] ?? null,
            'ip_address' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
            'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown'
        ];
        
        $this->write_error_log($error_entry);
        
        // Отправить предупреждение для критических ошибок
        if ($this->is_critical_error($error)) {
            $this->send_alert('CRITICAL_ERROR', $error);
        }
    }
}
```

## Резервное копирование и восстановление

### Процедуры резервного копирования

#### Резервное копирование базы данных
```bash
#!/bin/bash
# Скрипт резервного копирования базы данных

BACKUP_DIR="/var/backups/mysql"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="rechain_dao"

# Создать директорию резервных копий
mkdir -p $BACKUP_DIR

# Создать резервную копию базы данных
mysqldump --single-transaction --routines --triggers $DB_NAME > $BACKUP_DIR/${DB_NAME}_${DATE}.sql

# Сжать резервную копию
gzip $BACKUP_DIR/${DB_NAME}_${DATE}.sql

# Удалить старые резервные копии (оставить последние 30 дней)
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete

echo "Резервное копирование базы данных завершено: ${DB_NAME}_${DATE}.sql.gz"
```

#### Резервное копирование файловой системы
```bash
#!/bin/bash
# Скрипт резервного копирования файловой системы

BACKUP_DIR="/var/backups/filesystem"
SOURCE_DIR="/var/www/rechain-dao"
DATE=$(date +%Y%m%d_%H%M%S)

# Создать директорию резервных копий
mkdir -p $BACKUP_DIR

# Создать резервную копию файловой системы
tar -czf $BACKUP_DIR/rechain_dao_files_${DATE}.tar.gz -C $SOURCE_DIR .

# Удалить старые резервные копии (оставить последние 30 дней)
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete

echo "Резервное копирование файловой системы завершено: rechain_dao_files_${DATE}.tar.gz"
```

#### Автоматизированный скрипт резервного копирования
```bash
#!/bin/bash
# Автоматизированный скрипт резервного копирования

# Конфигурация
BACKUP_DIR="/var/backups/rechain_dao"
DB_NAME="rechain_dao"
SOURCE_DIR="/var/www/rechain-dao"
DATE=$(date +%Y%m%d_%H%M%S)

# Создать директорию резервных копий
mkdir -p $BACKUP_DIR

# Резервное копирование базы данных
echo "Начало резервного копирования базы данных..."
mysqldump --single-transaction --routines --triggers $DB_NAME | gzip > $BACKUP_DIR/db_${DATE}.sql.gz

# Резервное копирование файловой системы
echo "Начало резервного копирования файловой системы..."
tar -czf $BACKUP_DIR/files_${DATE}.tar.gz -C $SOURCE_DIR .

# Загрузка в облачное хранилище (опционально)
# aws s3 cp $BACKUP_DIR/db_${DATE}.sql.gz s3://rechain-dao-backups/
# aws s3 cp $BACKUP_DIR/files_${DATE}.tar.gz s3://rechain-dao-backups/

# Очистка старых резервных копий
find $BACKUP_DIR -name "*.sql.gz" -mtime +30 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete

echo "Резервное копирование успешно завершено"
```

### Процедуры восстановления

#### Восстановление базы данных
```bash
#!/bin/bash
# Скрипт восстановления базы данных

BACKUP_FILE=$1
DB_NAME="rechain_dao"

if [ -z "$BACKUP_FILE" ]; then
    echo "Использование: $0 <backup_file.sql.gz>"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Файл резервной копии не найден: $BACKUP_FILE"
    exit 1
fi

echo "Начало восстановления базы данных..."
echo "Файл резервной копии: $BACKUP_FILE"

# Остановить приложение
systemctl stop apache2

# Создать резервную копию базы данных перед восстановлением
mysqldump $DB_NAME > /tmp/db_before_recovery_$(date +%Y%m%d_%H%M%S).sql

# Восстановить базу данных
gunzip -c $BACKUP_FILE | mysql $DB_NAME

# Запустить приложение
systemctl start apache2

echo "Восстановление базы данных завершено"
```

#### Восстановление файловой системы
```bash
#!/bin/bash
# Скрипт восстановления файловой системы

BACKUP_FILE=$1
TARGET_DIR="/var/www/rechain-dao"

if [ -z "$BACKUP_FILE" ]; then
    echo "Использование: $0 <backup_file.tar.gz>"
    exit 1
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "Файл резервной копии не найден: $BACKUP_FILE"
    exit 1
fi

echo "Начало восстановления файловой системы..."
echo "Файл резервной копии: $BACKUP_FILE"
echo "Целевая директория: $TARGET_DIR"

# Остановить приложение
systemctl stop apache2

# Создать резервную копию текущих файлов
tar -czf /tmp/current_files_$(date +%Y%m%d_%H%M%S).tar.gz -C $TARGET_DIR .

# Восстановить файлы
tar -xzf $BACKUP_FILE -C $TARGET_DIR

# Установить правильные права доступа
chown -R www-data:www-data $TARGET_DIR
chmod -R 755 $TARGET_DIR

# Запустить приложение
systemctl start apache2

echo "Восстановление файловой системы завершено"
```

## Управление безопасностью

### Мониторинг безопасности

#### Неудачные попытки входа
```sql
-- Проверить неудачные попытки входа
SELECT 
    login_ip,
    COUNT(*) as attempt_count,
    MAX(login_time) as last_attempt
FROM failed_logins 
WHERE login_time > DATE_SUB(NOW(), INTERVAL 1 HOUR)
GROUP BY login_ip
HAVING attempt_count > 5
ORDER BY attempt_count DESC;
```

#### Подозрительная активность
```sql
-- Проверить подозрительную активность
SELECT 
    user_id,
    user_name,
    action_type,
    COUNT(*) as action_count,
    MAX(action_time) as last_action
FROM user_actions 
WHERE action_time > DATE_SUB(NOW(), INTERVAL 1 HOUR)
GROUP BY user_id, action_type
HAVING action_count > 100
ORDER BY action_count DESC;
```

### Обновления безопасности

#### Обновления системы
```bash
# Обновить системные пакеты
apt update
apt upgrade -y

# Обновить PHP
apt install php8.2-fpm php8.2-mysql php8.2-redis php8.2-gd php8.2-curl

# Обновить MySQL
apt install mysql-server-8.0

# Перезапустить сервисы
systemctl restart apache2
systemctl restart mysql
systemctl restart redis
```

#### Обновления приложения
```bash
# Обновить код приложения
cd /var/www/rechain-dao
git pull origin main

# Обновить зависимости
composer install --no-dev --optimize-autoloader
npm install --production

# Очистить кэши
php artisan cache:clear
php artisan config:cache
php artisan route:cache
```

## Оптимизация производительности

### Оптимизация базы данных

#### Оптимизация запросов
```sql
-- Анализ медленных запросов
SELECT 
    query_time,
    lock_time,
    rows_sent,
    rows_examined,
    sql_text
FROM mysql.slow_log 
WHERE query_time > 2
ORDER BY query_time DESC;

-- Проверить использование индексов
SELECT 
    table_name,
    index_name,
    cardinality
FROM information_schema.statistics 
WHERE table_schema = 'rechain_dao'
ORDER BY table_name, cardinality DESC;
```

#### Оптимизация индексов
```sql
-- Добавить недостающие индексы
ALTER TABLE posts ADD INDEX idx_post_created (post_created);
ALTER TABLE comments ADD INDEX idx_comment_created (comment_created);
ALTER TABLE users ADD INDEX idx_user_last_seen (user_last_seen);

-- Анализировать производительность таблиц
ANALYZE TABLE posts;
ANALYZE TABLE comments;
ANALYZE TABLE users;
```

### Оптимизация кэширования

#### Конфигурация Redis
```bash
# Конфигурация Redis
cat > /etc/redis/redis.conf << EOF
# Управление памятью
maxmemory 2gb
maxmemory-policy allkeys-lru

# Персистентность
save 900 1
save 300 10
save 60 10000

# Логирование
loglevel notice
logfile /var/log/redis/redis-server.log
EOF

# Перезапустить Redis
systemctl restart redis
```

#### Кэширование приложения
```php
// Конфигурация кэширования
class CacheManager {
    private $redis;
    
    public function __construct() {
        $this->redis = new Redis();
        $this->redis->connect('127.0.0.1', 6379);
    }
    
    public function cache_user_data($user_id) {
        $key = "user_data:{$user_id}";
        $data = $this->redis->get($key);
        
        if (!$data) {
            $data = $this->get_user_from_database($user_id);
            $this->redis->setex($key, 3600, json_encode($data));
        }
        
        return json_decode($data, true);
    }
}
```

## Устранение неполадок

### Частые проблемы

#### Высокое использование CPU
```bash
# Проверить процессы, использующие CPU
top -bn1 | head -20
ps aux --sort=-%cpu | head -10

# Проверить процессы MySQL
mysql -e "SHOW PROCESSLIST;"

# Проверить процессы Apache
ps aux | grep apache2
```

#### Высокое использование памяти
```bash
# Проверить использование памяти
free -h
ps aux --sort=-%mem | head -10

# Проверить использование памяти MySQL
mysql -e "SHOW STATUS LIKE 'Innodb_buffer_pool%';"
```

#### Проблемы с дисковым пространством
```bash
# Проверить использование диска
df -h
du -sh /var/www/rechain-dao/*
du -sh /var/lib/mysql/*

# Найти большие файлы
find /var/www/rechain-dao -type f -size +100M -exec ls -lh {} \;
```

### Проблемы с базой данных

#### Проблемы с подключением
```bash
# Проверить статус MySQL
systemctl status mysql
mysql -e "SHOW STATUS LIKE 'Threads_connected';"

# Проверить логи MySQL
tail -f /var/log/mysql/error.log
```

#### Проблемы с производительностью
```sql
-- Проверить медленные запросы
SHOW VARIABLES LIKE 'slow_query_log';
SHOW VARIABLES LIKE 'long_query_time';

-- Проверить блокировки таблиц
SHOW STATUS LIKE 'Table_locks%';

-- Проверить статус InnoDB
SHOW ENGINE INNODB STATUS;
```

### Проблемы с приложением

#### Ошибки PHP
```bash
# Проверить лог ошибок PHP
tail -f /var/log/php8.2-fpm.log

# Проверить лог ошибок Apache
tail -f /var/log/apache2/error.log

# Проверить лог ошибок приложения
tail -f /var/www/rechain-dao/logs/error.log
```

#### Проблемы с сессиями
```bash
# Проверить директорию сессий
ls -la /var/lib/php/sessions/
du -sh /var/lib/php/sessions/*

# Проверить конфигурацию сессий
php -i | grep session
```

## Процедуры обслуживания

### Ежедневное обслуживание

#### Ротация логов
```bash
# Настроить ротацию логов
cat > /etc/logrotate.d/rechain-dao << EOF
/var/www/rechain-dao/logs/*.log {
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 644 www-data www-data
}
EOF
```

#### Обслуживание базы данных
```sql
-- Ежедневное обслуживание базы данных
OPTIMIZE TABLE posts;
OPTIMIZE TABLE comments;
OPTIMIZE TABLE users;
OPTIMIZE TABLE messages;

-- Проверить целостность таблиц
CHECK TABLE posts;
CHECK TABLE comments;
CHECK TABLE users;
CHECK TABLE messages;
```

### Еженедельное обслуживание

#### Обновления системы
```bash
# Еженедельные обновления системы
apt update
apt upgrade -y

# Обновить зависимости приложения
cd /var/www/rechain-dao
composer update --no-dev
npm update
```

#### Сканирование безопасности
```bash
# Сканирование уязвимостей безопасности
apt install lynis
lynis audit system

# Проверить на руткиты
apt install rkhunter
rkhunter --update
rkhunter --check
```

### Ежемесячное обслуживание

#### Анализ производительности
```sql
-- Ежемесячный анализ производительности
SELECT 
    table_name,
    table_rows,
    data_length,
    index_length,
    (data_length + index_length) as total_size
FROM information_schema.tables 
WHERE table_schema = 'rechain_dao'
ORDER BY total_size DESC;
```

#### Анализ активности пользователей
```sql
-- Ежемесячный анализ активности пользователей
SELECT 
    DATE(user_registered) as registration_date,
    COUNT(*) as new_users
FROM users 
WHERE user_registered > DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY DATE(user_registered)
ORDER BY registration_date DESC;
```

## Процедуры экстренного реагирования

### Система недоступна

#### Немедленное реагирование
1. **Проверить сервисы**: Убедиться, что все критические сервисы работают
2. **Проверить логи**: Просмотреть логи ошибок на предмет проблем
3. **Проверить ресурсы**: Убедиться в доступности CPU, памяти и дискового пространства
4. **Перезапустить сервисы**: Перезапустить неработающие сервисы
5. **Уведомить команду**: Предупредить команду разработки

#### Шаги восстановления
```bash
# Экстренный перезапуск сервисов
systemctl restart apache2
systemctl restart mysql
systemctl restart redis

# Проверить статус сервисов
systemctl status apache2
systemctl status mysql
systemctl status redis
```

### Повреждение данных

#### Повреждение базы данных
```sql
-- Проверить на повреждение
CHECK TABLE posts;
CHECK TABLE comments;
CHECK TABLE users;
CHECK TABLE messages;

-- Восстановить при необходимости
REPAIR TABLE posts;
REPAIR TABLE comments;
REPAIR TABLE users;
REPAIR TABLE messages;
```

#### Повреждение файловой системы
```bash
# Проверить файловую систему
fsck /dev/sda1

# Проверить права доступа к файлам
find /var/www/rechain-dao -type f ! -perm 644 -exec chmod 644 {} \;
find /var/www/rechain-dao -type d ! -perm 755 -exec chmod 755 {} \;
```

### Нарушение безопасности

#### Немедленное реагирование
1. **Изолировать систему**: Отключить от сети при необходимости
2. **Сохранить доказательства**: Сохранить логи и состояние системы
3. **Оценить ущерб**: Определить масштаб нарушения
4. **Уведомить власти**: Связаться с командой безопасности и руководством
5. **Документировать все**: Записать все предпринятые действия

#### Шаги восстановления
1. **Очистить систему**: Удалить вредоносный код
2. **Обновить безопасность**: Применить патчи безопасности
3. **Изменить учетные данные**: Обновить все пароли
4. **Восстановить из резервной копии**: Использовать чистую резервную копию при необходимости
5. **Мониторить**: Усиленный мониторинг подозрительной активности

## Лучшие практики

### Системное администрирование

#### Регулярные задачи
- **Ежедневно**: Проверка состояния системы, обзор логов, мониторинг пользователей
- **Еженедельно**: Обновление пакетов, анализ производительности, сканирование безопасности
- **Ежемесячно**: Полное резервное копирование системы, анализ производительности, отчеты пользователей
- **Ежеквартально**: Аудит безопасности, тестирование аварийного восстановления

#### Документация
- **Ведение записей**: Документировать все изменения и процедуры
- **Обновление документации**: Поддерживать руководства в актуальном состоянии
- **Обмен знаниями**: Обучать членов команды
- **Контроль версий**: Отслеживать изменения конфигурации

### Лучшие практики безопасности

#### Контроль доступа
- **Принцип минимальных привилегий**: Минимально необходимый доступ
- **Регулярные проверки доступа**: Аудит разрешений пользователей
- **Надежная аутентификация**: Принудительное использование 2FA для администраторов
- **Аудит логирования**: Логирование всех административных действий

#### Мониторинг
- **Предупреждения в реальном времени**: Настройка мониторинга предупреждений
- **Регулярные обзоры**: Обзор логов и метрик
- **Реагирование на инциденты**: Четкие процедуры
- **Непрерывное улучшение**: Обучение на инцидентах

### Лучшие практики производительности

#### Оптимизация
- **Регулярный мониторинг**: Отслеживание метрик производительности
- **Проактивная настройка**: Оптимизация до возникновения проблем
- **Планирование мощности**: Планирование роста
- **Нагрузочное тестирование**: Тестирование в различных условиях

#### Обслуживание
- **Запланированное обслуживание**: Планирование окон обслуживания
- **Тестирование резервных копий**: Регулярное тестирование резервных копий
- **Управление обновлениями**: Поддержание систем в актуальном состоянии
- **Документация**: Поддержание актуальной документации

## Заключение

Это руководство системного администратора предоставляет комплексную информацию для управления платформой REChain DAO. Регулярное соблюдение этих процедур обеспечит стабильную, безопасную и производительную систему.

Помните: Системное администрирование - это непрерывный процесс, требующий постоянного внимания, мониторинга и улучшения. Будьте бдительны, продолжайте учиться и всегда будьте готовы к неожиданному.
