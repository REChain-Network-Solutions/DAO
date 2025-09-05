# REChain DAO - Руководство для разработчиков

## Содержание

1. [Начало работы](#начало-работы)
2. [Настройка среды разработки](#настройка-среды-разработки)
3. [Структура кода](#структура-кода)
4. [Схема базы данных](#схема-базы-данных)
5. [Разработка API](#разработка-api)
6. [Разработка фронтенда](#разработка-фронтенда)
7. [Тестирование](#тестирование)
8. [Отладка](#отладка)
9. [Оптимизация производительности](#оптимизация-производительности)
10. [Лучшие практики безопасности](#лучшие-практики-безопасности)
11. [Развертывание](#развертывание)
12. [Участие в проекте](#участие-в-проекте)

## Начало работы

### Предварительные требования

Перед началом разработки убедитесь, что у вас есть:

- **PHP 8.2+** с необходимыми расширениями
- **MySQL 5.7+** или **MariaDB 10.3+**
- **Composer** для управления зависимостями
- **Node.js 16+** и **npm** для фронтенд ресурсов
- **Git** для контроля версий
- **Docker** (опционально, для контейнеризованной разработки)

### Быстрый старт

1. **Клонировать репозиторий:**
   ```bash
   git clone https://github.com/REChain-Network-Solutions/DAO.git
   cd DAO
   ```

2. **Установить зависимости:**
   ```bash
   composer install
   npm install
   ```

3. **Настроить окружение:**
   ```bash
   cp includes/config-example.php includes/config.php
   # Отредактировать config.php с вашими настройками
   ```

4. **Инициализировать базу данных:**
   ```bash
   mysql -u root -p < Extras/SQL/schema.sql
   ```

5. **Запустить сервер разработки:**
   ```bash
   php -S localhost:8000
   ```

## Настройка среды разработки

### Локальная разработка с Docker

1. **Создать docker-compose.yml:**
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

2. **Запустить сервисы:**
   ```bash
   docker-compose up -d
   ```

### Конфигурация IDE

#### Настройка VS Code

1. **Установить расширения:**
   - PHP Intelephense
   - PHP Debug
   - MySQL
   - GitLens
   - Prettier

2. **Настроить settings.json:**
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

#### Настройка PhpStorm

1. **Настроить интерпретатор PHP**
2. **Настроить подключение к базе данных**
3. **Включить поддержку шаблонов Smarty**
4. **Настроить стиль кода**

## Структура кода

### Организация каталогов

```
REChain-DAO/
├── admin.php                 # Точка входа панели администратора
├── api.php                   # Главная точка входа API
├── bootstrap.php             # Загрузчик приложения
├── index.php                 # Главная точка входа приложения
├── includes/                 # Основные системные файлы
│   ├── class-user.php        # Основной класс пользователя
│   ├── functions.php         # Основные функции
│   ├── traits/              # Модульная функциональность
│   │   ├── AdsTrait.php
│   │   ├── ChatTrait.php
│   │   └── ...
│   └── config.php           # Конфигурация
├── content/                 # Статический контент
│   ├── themes/              # UI темы
│   │   └── default/
│   │       ├── css/
│   │       ├── js/
│   │       └── tpl/
│   ├── languages/           # Локализация
│   └── uploads/             # Загрузки пользователей
├── apis/                    # Реализации API
│   └── php/
│       ├── modules/         # Модули API
│       └── routes/          # Маршруты API
├── modules/                 # Модули функций
├── vendor/                  # Зависимости Composer
└── docs/                    # Документация
```

### Основные классы

#### Класс User (`includes/class-user.php`)

Основной класс пользователя использует трейты для модульной функциональности:

```php
class User
{
    use AdsTrait,
        AffiliatesTrait,
        AnnouncementsTrait,
        // ... другие трейты
    
    public $_logged_in = false;
    public $_is_admin = false;
    public $_data = [];
    
    // Основные методы
    public function signin($email, $password) { }
    public function signup($data) { }
    public function get_user($user_id) { }
}
```

#### Система трейтов

Трейты обеспечивают модульную функциональность:

```php
trait PostsTrait
{
    public function get_posts($offset = 0, $limit = 20, $type = 'newsfeed')
    {
        // Реализация
    }
    
    public function create_post($data)
    {
        // Реализация
    }
}
```

### Слой базы данных

#### Управление подключениями

```php
// Подключение к базе данных в bootstrap.php
$db = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME, DB_PORT);

// Вспомогательные функции запросов
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

#### Схема базы данных

Ключевые таблицы:
- `users` - Учетные записи пользователей
- `posts` - Посты в социальных сетях
- `comments` - Комментарии к постам
- `messages` - Сообщения чата
- `groups` - Группы пользователей
- `pages` - Бизнес-страницы
- `notifications` - Уведомления пользователей

## Разработка API

### Создание новых API endpoints

1. **Создать контроллер:**
   ```php
   // apis/php/modules/yourmodule/controller.php
   function yourFunction($req, $res)
   {
       global $user;
       
       // Валидация входных данных
       if (!isset($req->body['param'])) {
           throw new ValidationException("Параметр обязателен");
       }
       
       // Обработка запроса
       $result = $user->your_method($req->body['param']);
       
       // Возврат ответа
       apiResponse($res, ['data' => $result]);
   }
   ```

2. **Создать роутер:**
   ```php
   // apis/php/modules/yourmodule/router.php
   $app->post('/your-endpoint', 'yourFunction');
   ```

3. **Зарегистрировать маршруты:**
   ```php
   // apis/php/routes/modules.php
   require('modules/yourmodule/router.php');
   ```

### Вспомогательные функции API ответов

```php
// Успешный ответ
apiResponse($res, ['data' => $data]);

// Ответ с ошибкой
apiError('Сообщение об ошибке', 400);

// Ошибка валидации
throw new ValidationException('Неверные входные данные');
```

### Middleware аутентификации

```php
function requireAuth($req, $res, $next)
{
    global $user;
    
    if (!$user->_logged_in) {
        apiError('Требуется аутентификация', 401);
    }
    
    $next();
}

// Использование middleware
$app->get('/protected-endpoint', 'requireAuth', 'yourFunction');
```

## Разработка фронтенда

### Система шаблонов (Smarty)

#### Создание шаблонов

```smarty
{* content/themes/default/tpl/your_template.tpl *}
<div class="your-component">
    <h1>{$title}</h1>
    {if $user._logged_in}
        <p>Добро пожаловать, {$user.user_firstname}!</p>
    {/if}
</div>
```

#### Переменные шаблонов

```php
// В вашем PHP файле
$smarty->assign('title', 'Ваш заголовок');
$smarty->assign('data', $your_data);
$smarty->display('your_template.tpl');
```

### Разработка JavaScript

#### Система модулей

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
            // Ваша логика здесь
        }
    };
    
    $(document).ready(function() {
        YourModule.init();
    });
    
})(jQuery);
```

#### AJAX запросы

```javascript
// Используя встроенный AJAX помощник
$.post('ajax/your-endpoint.php', {
    param1: 'value1',
    param2: 'value2'
}, function(response) {
    if (response.error) {
        alert(response.message);
    } else {
        // Обработка успеха
        console.log(response.data);
    }
}, 'json');
```

### Разработка CSS

#### Структура SCSS

```scss
// content/themes/default/scss/main.scss
@import 'variables';
@import 'mixins';
@import 'base';
@import 'components/your-component';
@import 'pages/your-page';
```

#### Стили компонентов

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

## Тестирование

### Модульное тестирование

#### Настройка PHPUnit

1. **Установить PHPUnit:**
   ```bash
   composer require --dev phpunit/phpunit
   ```

2. **Создать конфигурацию тестов:**
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

3. **Написать тесты:**
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

### Тестирование API

#### Использование Postman

1. **Создать коллекцию**
2. **Настроить переменные окружения**
3. **Создать тестовые скрипты**

```javascript
// Скрипт тестирования Postman
pm.test("Код статуса 200", function () {
    pm.response.to.have.status(200);
});

pm.test("Ответ содержит обязательные поля", function () {
    var jsonData = pm.response.json();
    pm.expect(jsonData).to.have.property('success');
    pm.expect(jsonData).to.have.property('data');
});
```

#### Автоматизированное тестирование API

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
                'post_text' => 'Тестовый пост',
                'post_privacy' => 'public'
            ]
        ]);
        
        $this->assertEquals(200, $response->getStatusCode());
    }
}
```

## Отладка

### Отладка PHP

#### Настройка Xdebug

1. **Установить Xdebug:**
   ```bash
   pecl install xdebug
   ```

2. **Настроить php.ini:**
   ```ini
   [xdebug]
   zend_extension=xdebug.so
   xdebug.mode=debug
   xdebug.start_with_request=yes
   xdebug.client_host=127.0.0.1
   xdebug.client_port=9003
   ```

3. **Настроить VS Code:**
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

#### Логирование

```php
// Пользовательская функция логирования
function debug_log($message, $level = 'INFO')
{
    $log_file = ABSPATH . 'content/logs/debug.log';
    $timestamp = date('Y-m-d H:i:s');
    $log_entry = "[$timestamp] [$level] $message" . PHP_EOL;
    file_put_contents($log_file, $log_entry, FILE_APPEND | LOCK_EX);
}

// Использование
debug_log('Попытка входа пользователя: ' . $email);
debug_log('Ошибка базы данных: ' . $error, 'ERROR');
```

### Отладка фронтенда

#### Инструменты разработчика браузера

1. **Отладка консоли:**
   ```javascript
   console.log('Отладочная информация:', data);
   console.error('Произошла ошибка:', error);
   console.table(arrayData);
   ```

2. **Мониторинг сети:**
   - Проверка API запросов
   - Мониторинг времени ответа
   - Отладка неудачных запросов

#### Обработка ошибок JavaScript

```javascript
try {
    // Ваш код здесь
    riskyOperation();
} catch (error) {
    console.error('Ошибка:', error);
    // Показать понятное пользователю сообщение
    showNotification('Произошла ошибка. Попробуйте еще раз.');
}
```

## Оптимизация производительности

### Оптимизация базы данных

#### Оптимизация запросов

```php
// Использовать подготовленные выражения
$stmt = $db->prepare("SELECT * FROM users WHERE user_id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

// Использовать индексы
CREATE INDEX idx_user_email ON users(user_email);
CREATE INDEX idx_post_created ON posts(post_created);

// Оптимизировать запросы
EXPLAIN SELECT * FROM posts WHERE user_id = 123 ORDER BY post_created DESC;
```

#### Кэширование

```php
// Простое файловое кэширование
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

// Использование
$posts = get_cached_data('user_posts_' . $user_id, function() use ($user_id) {
    return $user->get_posts($user_id);
});
```

### Оптимизация фронтенда

#### Оптимизация ресурсов

```javascript
// Минификация CSS и JS
npm run build

// Использование CDN для библиотек
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>

// Ленивая загрузка изображений
<img src="placeholder.jpg" data-src="actual-image.jpg" class="lazy">
```

#### Заголовки кэширования

```apache
# .htaccess
<IfModule mod_expires.c>
    ExpiresActive On
    ExpiresByType text/css "access plus 1 month"
    ExpiresByType application/javascript "access plus 1 month"
    ExpiresByType image/png "access plus 1 year"
</IfModule>
```

## Лучшие практики безопасности

### Валидация входных данных

```php
// Валидация и санитизация входных данных
function validate_email($email)
{
    return filter_var($email, FILTER_VALIDATE_EMAIL);
}

function sanitize_string($string)
{
    return htmlspecialchars(trim($string), ENT_QUOTES, 'UTF-8');
}

// Использование в коде
$email = validate_email($_POST['email']);
if (!$email) {
    throw new ValidationException('Неверный адрес электронной почты');
}
```

### Предотвращение SQL-инъекций

```php
// Всегда использовать подготовленные выражения
$stmt = $db->prepare("SELECT * FROM users WHERE user_email = ? AND user_password = ?");
$stmt->bind_param("ss", $email, $hashed_password);
$stmt->execute();
```

### Предотвращение XSS

```php
// Экранирование вывода
echo htmlspecialchars($user_input, ENT_QUOTES, 'UTF-8');

// В шаблонах Smarty
{$user_input|escape:'html'}
```

### Защита от CSRF

```php
// Генерация CSRF токена
function generate_csrf_token()
{
    if (!isset($_SESSION['csrf_token'])) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
    }
    return $_SESSION['csrf_token'];
}

// Валидация CSRF токена
function validate_csrf_token($token)
{
    return isset($_SESSION['csrf_token']) && hash_equals($_SESSION['csrf_token'], $token);
}
```

## Развертывание

### Развертывание в продакшене

#### Требования к серверу

- **PHP 8.2+** с включенным OPcache
- **MySQL 8.0+** с правильной конфигурацией
- **Nginx** или **Apache** с mod_rewrite
- **SSL сертификат** (рекомендуется Let's Encrypt)
- **Redis** для кэширования (опционально, но рекомендуется)

#### Шаги развертывания

1. **Подготовить продакшн окружение:**
   ```bash
   # Обновить систему
   sudo apt update && sudo apt upgrade -y
   
   # Установить необходимые пакеты
   sudo apt install nginx mysql-server php8.3-fpm php8.3-mysql
   ```

2. **Развернуть приложение:**
   ```bash
   # Клонировать репозиторий
   git clone https://github.com/REChain-Network-Solutions/DAO.git /var/www/html
   
   # Установить права доступа
   sudo chown -R www-data:www-data /var/www/html
   sudo chmod -R 755 /var/www/html
   sudo chmod -R 777 /var/www/html/content/uploads
   ```

3. **Настроить веб-сервер:**
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

4. **Настроить SSL:**
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

## Участие в проекте

### Рабочий процесс разработки

1. **Форкнуть репозиторий**
2. **Создать ветку функции:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Внести изменения**
4. **Написать тесты для изменений**
5. **Запустить набор тестов:**
   ```bash
   composer test
   npm test
   ```

6. **Зафиксировать изменения:**
   ```bash
   git commit -m "Добавить вашу функцию"
   ```

7. **Отправить в ваш форк:**
   ```bash
   git push origin feature/your-feature-name
   ```

8. **Создать Pull Request**

### Руководящие принципы стиля кода

#### Стиль кода PHP

- Следовать стандартам кодирования PSR-12
- Использовать осмысленные имена переменных и функций
- Добавлять PHPDoc комментарии для функций и классов
- Делать функции небольшими и сфокусированными

```php
/**
 * Создать новый пост для пользователя
 *
 * @param int $user_id ID пользователя
 * @param array $data Данные поста
 * @return bool|int ID поста при успехе, false при неудаче
 * @throws ValidationException
 */
public function create_post($user_id, $data)
{
    // Реализация
}
```

#### Стиль кода JavaScript

- Использовать конфигурацию ESLint
- Следовать согласованным соглашениям об именовании
- Использовать осмысленные комментарии
- Делать функции небольшими и сфокусированными

```javascript
/**
 * Обработать отправку формы входа пользователя
 * @param {Event} event - Событие отправки формы
 */
function handleLoginSubmit(event) {
    event.preventDefault();
    // Реализация
}
```

### Руководящие принципы Pull Request

1. **Четкое описание** того, что делает PR
2. **Ссылки на проблемы**, которые решает PR
3. **Включить тесты** для новой функциональности
4. **Обновить документацию** при необходимости
5. **Скриншоты** для изменений UI

### Процесс ревью кода

1. **Автоматические проверки** должны пройти
2. **Требуется одобрение** как минимум одного ревьюера
3. **Нет конфликтов слияния**
4. **Все тесты проходят**
5. **Документация обновлена**

---

*Это руководство для разработчиков предоставляет всестороннюю информацию для участия в проекте REChain DAO. Для конкретных вопросов или продвинутых тем обратитесь к документации отдельных компонентов или свяжитесь с командой разработки.*
