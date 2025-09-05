# REChain DAO - Документация API

## Обзор

API REChain DAO предоставляет комплексный RESTful интерфейс для взаимодействия с платформой социальных сетей. API построен с использованием модульной архитектуры с маршрутизацией в стиле Express.js и поддерживает как веб-приложения, так и мобильные приложения.

## Базовый URL

```
https://your-domain.com/apis/php
```

## Аутентификация

### OAuth 2.0 Flow

API использует OAuth 2.0 для аутентификации со следующим процессом:

1. **Получить код авторизации**
   ```
   GET /oauth?app_id={app_id}
   ```

2. **Обменять код на токен доступа**
   ```
   POST /authorize
   Content-Type: application/json
   
   {
     "app_id": "your_app_id",
     "app_secret": "your_app_secret",
     "auth_key": "authorization_code"
   }
   ```

3. **Использовать токен доступа**
   Включите токен доступа в запросы:
   ```
   Authorization: Bearer {access_token}
   ```

### Аутентификация по API ключу

Для сервер-серверного взаимодействия можно использовать API ключи:

```
X-API-Key: your_api_key
```

## Формат ответа

Все ответы API следуют единому JSON формату:

### Успешный ответ
```json
{
  "success": true,
  "data": {
    // Данные ответа
  },
  "message": "Сообщение об успехе"
}
```

### Ответ с ошибкой
```json
{
  "error": true,
  "message": "Описание ошибки",
  "code": "КОД_ОШИБКИ"
}
```

## Основные endpoints

### Проверка состояния

#### Ping
```http
GET /ping
```

**Ответ:**
```json
{
  "message": "pong"
}
```

### Endpoints ошибок

- `GET /400` - Неверный запрос
- `GET /401` - Не авторизован
- `GET /403` - Запрещено
- `GET /404` - Не найдено
- `GET /500` - Внутренняя ошибка сервера

## API управления пользователями

### Аутентификация

#### Вход
```http
POST /auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

**Ответ:**
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

#### Регистрация
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

#### Выход
```http
POST /auth/logout
Authorization: Bearer {access_token}
```

### Профиль пользователя

#### Получить информацию о пользователе
```http
GET /user/info?access_token={access_token}
```

**Ответ:**
```json
{
  "success": true,
  "data": {
    "user_id": 123,
    "user_name": "john_doe",
    "user_email": "user@example.com",
    "user_firstname": "John",
    "user_lastname": "Doe",
    "user_gender": "Мужской",
    "user_birthdate": "1990-01-01",
    "profile_picture": "https://domain.com/uploads/profile_pic.jpg",
    "profile_cover": "https://domain.com/uploads/cover.jpg",
    "user_registered": "2023-01-01 12:00:00",
    "user_verified": true,
    "user_relationship": "Не женат/не замужем",
    "user_biography": "Биография пользователя",
    "user_website": "https://example.com"
  }
}
```

#### Обновить профиль
```http
PUT /user/profile
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "user_firstname": "John",
  "user_lastname": "Doe",
  "user_biography": "Обновлённая биография",
  "user_website": "https://newwebsite.com"
}
```

#### Загрузить аватар
```http
POST /user/avatar
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

file: [image_file]
```

#### Удалить аватар/обложку
```http
DELETE /user/avatar-cover
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "handle": "avatar" // или "cover"
}
```

### Связи пользователей

#### Связать пользователя
```http
POST /user/connect
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "do": "follow", // follow, unfollow, block, unblock
  "id": 456, // ID целевого пользователя
  "uid": 789 // опционально: конкретный ID пользователя
}
```

#### Получить связи пользователя
```http
GET /user/connections?type=followers&user_id=123
Authorization: Bearer {access_token}
```

## API постов

### Создать пост
```http
POST /posts
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "post_text": "Это содержимое моего поста",
  "post_privacy": "public", // public, friends, me
  "post_type": "text", // text, photo, video, link
  "post_photos": ["photo1.jpg", "photo2.jpg"], // опционально
  "post_video": "video.mp4", // опционально
  "post_link": "https://example.com", // опционально
  "post_link_title": "Заголовок ссылки", // опционально
  "post_link_description": "Описание ссылки", // опционально
  "post_link_image": "link_image.jpg" // опционально
}
```

### Получить посты
```http
GET /posts?offset=0&limit=20&type=newsfeed
Authorization: Bearer {access_token}
```

**Параметры запроса:**
- `offset` - Количество постов для пропуска (по умолчанию: 0)
- `limit` - Количество постов для возврата (по умолчанию: 20)
- `type` - Тип постов (newsfeed, profile, page, group)
- `user_id` - ID пользователя для постов профиля
- `page_id` - ID страницы для постов страницы
- `group_id` - ID группы для постов группы

### Получить один пост
```http
GET /posts/{post_id}
Authorization: Bearer {access_token}
```

### Обновить пост
```http
PUT /posts/{post_id}
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "post_text": "Обновлённое содержимое поста",
  "post_privacy": "friends"
}
```

### Удалить пост
```http
DELETE /posts/{post_id}
Authorization: Bearer {access_token}
```

### Взаимодействие с постами

#### Лайкнуть пост
```http
POST /posts/{post_id}/like
Authorization: Bearer {access_token}
```

#### Убрать лайк с поста
```http
DELETE /posts/{post_id}/like
Authorization: Bearer {access_token}
```

#### Комментировать пост
```http
POST /posts/{post_id}/comments
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "comment_text": "Это комментарий"
}
```

#### Получить комментарии к посту
```http
GET /posts/{post_id}/comments?offset=0&limit=20
Authorization: Bearer {access_token}
```

## API чата

### Получить разговоры
```http
GET /chat/conversations
Authorization: Bearer {access_token}
```

### Получить сообщения
```http
GET /chat/conversations/{conversation_id}/messages?offset=0&limit=50
Authorization: Bearer {access_token}
```

### Отправить сообщение
```http
POST /chat/conversations/{conversation_id}/messages
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "message_text": "Привет!",
  "message_type": "text" // text, image, video, file
}
```

### Отправить файловое сообщение
```http
POST /chat/conversations/{conversation_id}/messages
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

message_text: "Посмотрите этот файл"
message_type: "file"
file: [file_data]
```

### Отметить сообщения как прочитанные
```http
PUT /chat/conversations/{conversation_id}/read
Authorization: Bearer {access_token}
```

## API групп

### Создать группу
```http
POST /groups
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "group_name": "Моя группа",
  "group_title": "Заголовок группы",
  "group_description": "Описание группы",
  "group_privacy": "public", // public, closed, secret
  "group_category": 1
}
```

### Получить группы
```http
GET /groups?offset=0&limit=20&type=joined
Authorization: Bearer {access_token}
```

**Параметры запроса:**
- `type` - joined, suggested, search
- `search` - Поисковый запрос
- `category` - ID категории

### Присоединиться к группе
```http
POST /groups/{group_id}/join
Authorization: Bearer {access_token}
```

### Покинуть группу
```http
DELETE /groups/{group_id}/join
Authorization: Bearer {access_token}
```

## API страниц

### Создать страницу
```http
POST /pages
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "page_name": "my_page",
  "page_title": "Моя страница",
  "page_description": "Описание страницы",
  "page_category": 1
}
```

### Получить страницы
```http
GET /pages?offset=0&limit=20&type=liked
Authorization: Bearer {access_token}
```

### Лайкнуть страницу
```http
POST /pages/{page_id}/like
Authorization: Bearer {access_token}
```

## API уведомлений

### Получить уведомления
```http
GET /notifications?offset=0&limit=20&type=all
Authorization: Bearer {access_token}
```

**Параметры запроса:**
- `type` - all, likes, comments, follows, mentions

### Отметить уведомление как прочитанное
```http
PUT /notifications/{notification_id}/read
Authorization: Bearer {access_token}
```

### Отметить все уведомления как прочитанные
```http
PUT /notifications/read-all
Authorization: Bearer {access_token}
```

## API поиска

### Поиск пользователей
```http
GET /search/users?q=john&offset=0&limit=20
Authorization: Bearer {access_token}
```

### Поиск постов
```http
GET /search/posts?q=ключевое_слово&offset=0&limit=20
Authorization: Bearer {access_token}
```

### Поиск групп
```http
GET /search/groups?q=название_группы&offset=0&limit=20
Authorization: Bearer {access_token}
```

## API загрузки файлов

### Загрузить изображение
```http
POST /upload/image
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

file: [image_file]
```

**Ответ:**
```json
{
  "success": true,
  "data": {
    "file_name": "uploaded_image.jpg",
    "file_url": "https://domain.com/uploads/image.jpg"
  }
}
```

### Загрузить видео
```http
POST /upload/video
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

file: [video_file]
```

### Загрузить файл
```http
POST /upload/file
Authorization: Bearer {access_token}
Content-Type: multipart/form-data

file: [file_data]
```

## API монетизации

### Получить баланс кошелька
```http
GET /wallet/balance
Authorization: Bearer {access_token}
```

### Получить транзакции
```http
GET /wallet/transactions?offset=0&limit=20
Authorization: Bearer {access_token}
```

### Создать платёж
```http
POST /payments
Authorization: Bearer {access_token}
Content-Type: application/json

{
  "amount": 100.00,
  "currency": "USD",
  "description": "Описание платежа",
  "payment_method": "stripe"
}
```

## Ограничение скорости

API реализует ограничение скорости для обеспечения справедливого использования:

- **Общий API**: 1000 запросов в час на пользователя
- **Аутентификация**: 10 запросов в минуту на IP
- **Загрузка файлов**: 50 запросов в час на пользователя
- **Поиск**: 100 запросов в час на пользователя

Заголовки ограничения скорости включены в ответы:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
```

## Коды ошибок

| Код | Описание |
|-----|----------|
| 400 | Неверный запрос - Неверные параметры |
| 401 | Не авторизован - Неверная или отсутствующая аутентификация |
| 403 | Запрещено - Недостаточно прав |
| 404 | Не найдено - Ресурс не найден |
| 422 | Необрабатываемая сущность - Ошибки валидации |
| 429 | Слишком много запросов - Превышен лимит скорости |
| 500 | Внутренняя ошибка сервера - Ошибка сервера |

## SDK и библиотеки

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

// Вход
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

// Вход
$user = $client->auth->login([
    'email' => 'user@example.com',
    'password' => 'password123'
]);
```

## Webhooks

API поддерживает webhooks для уведомлений в реальном времени:

### События Webhook
- `user.created` - Регистрация нового пользователя
- `post.created` - Создание нового поста
- `post.liked` - Лайк поста
- `comment.created` - Новый комментарий
- `message.sent` - Отправлено новое сообщение
- `notification.created` - Новое уведомление

### Конфигурация Webhook
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

## Тестирование

### Коллекция Postman
Доступна коллекция Postman для тестирования API:
- Скачать: [Коллекция API](https://github.com/REChain-Network-Solutions/DAO/tree/main/docs/postman)
- Импортировать в Postman и настроить переменные окружения

### Инструменты тестирования API
- **Postman**: GUI-инструмент для тестирования API
- **curl**: Тестирование из командной строки
- **Insomnia**: Альтернативный GUI-инструмент
- **Newman**: CLI для коллекций Postman

## Поддержка

Для поддержки API и вопросов:
- **Документация**: Проверьте эту документацию
- **Проблемы**: Сообщите в GitHub Issues
- **Email**: api-support@rechain.network
- **Discord**: Присоединяйтесь к нашему сообществу разработчиков

---

*Эта документация API охватывает основные endpoints и функциональность. Для дополнительных деталей и расширенного использования обратитесь к документации отдельных модулей.*
