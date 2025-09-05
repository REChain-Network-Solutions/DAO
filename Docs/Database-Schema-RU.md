# Документация схемы базы данных

## Обзор

Этот документ предоставляет полный обзор схемы базы данных REChain DAO, включая структуры таблиц, связи, индексы и примеры запросов.

## Информация о базе данных

- **Тип базы данных**: MySQL
- **Версия**: 8.0+
- **Кодировка**: utf8mb4
- **Сортировка**: utf8mb4_unicode_ci
- **Движок**: InnoDB

## Основные таблицы

### Таблица Users

Центральная таблица для управления пользователями и аутентификации.

```sql
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(50) NOT NULL,
  `user_email` varchar(100) NOT NULL,
  `user_password` varchar(255) NOT NULL,
  `user_firstname` varchar(50) DEFAULT NULL,
  `user_lastname` varchar(50) DEFAULT NULL,
  `user_gender` enum('male','female','other') DEFAULT NULL,
  `user_birthdate` date DEFAULT NULL,
  `user_picture` varchar(255) DEFAULT NULL,
  `user_cover` varchar(255) DEFAULT NULL,
  `user_registered` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_verified` tinyint(1) NOT NULL DEFAULT '0',
  `user_relationship` enum('single','in_relationship','married','divorced','widowed') DEFAULT NULL,
  `user_biography` text,
  `user_website` varchar(255) DEFAULT NULL,
  `user_demo` tinyint(1) NOT NULL DEFAULT '0',
  `user_banned` tinyint(1) NOT NULL DEFAULT '0',
  `user_admin` tinyint(1) NOT NULL DEFAULT '0',
  `user_moderator` tinyint(1) NOT NULL DEFAULT '0',
  `user_last_seen` datetime DEFAULT NULL,
  `user_privacy` text,
  `user_notifications` text,
  `user_settings` text,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_name` (`user_name`),
  UNIQUE KEY `user_email` (`user_email`),
  KEY `user_registered` (`user_registered`),
  KEY `user_verified` (`user_verified`),
  KEY `user_banned` (`user_banned`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Таблица Posts

Хранит посты и контент пользователей.

```sql
CREATE TABLE `posts` (
  `post_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `post_type` enum('text','photo','video','link','poll') NOT NULL DEFAULT 'text',
  `post_text` text,
  `post_media` text,
  `post_privacy` enum('public','friends','me') NOT NULL DEFAULT 'public',
  `post_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `post_updated` datetime DEFAULT NULL,
  `post_likes` int(11) NOT NULL DEFAULT '0',
  `post_comments` int(11) NOT NULL DEFAULT '0',
  `post_shares` int(11) NOT NULL DEFAULT '0',
  `post_views` int(11) NOT NULL DEFAULT '0',
  `post_pinned` tinyint(1) NOT NULL DEFAULT '0',
  `post_boosted` tinyint(1) NOT NULL DEFAULT '0',
  `post_boosted_until` datetime DEFAULT NULL,
  PRIMARY KEY (`post_id`),
  KEY `user_id` (`user_id`),
  KEY `post_type` (`post_type`),
  KEY `post_created` (`post_created`),
  KEY `post_privacy` (`post_privacy`),
  KEY `post_boosted` (`post_boosted`),
  CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Таблица Comments

Хранит комментарии к постам.

```sql
CREATE TABLE `comments` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `comment_text` text NOT NULL,
  `comment_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `comment_updated` datetime DEFAULT NULL,
  `comment_likes` int(11) NOT NULL DEFAULT '0',
  `comment_replies` int(11) NOT NULL DEFAULT '0',
  `comment_parent` int(11) DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `post_id` (`post_id`),
  KEY `user_id` (`user_id`),
  KEY `comment_created` (`comment_created`),
  KEY `comment_parent` (`comment_parent`),
  CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`post_id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `comments_ibfk_3` FOREIGN KEY (`comment_parent`) REFERENCES `comments` (`comment_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Таблица Friends

Управляет дружбой и связями между пользователями.

```sql
CREATE TABLE `friends` (
  `friendship_id` int(11) NOT NULL AUTO_INCREMENT,
  `user1_id` int(11) NOT NULL,
  `user2_id` int(11) NOT NULL,
  `status` enum('pending','accepted','blocked') NOT NULL DEFAULT 'pending',
  `created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated` datetime DEFAULT NULL,
  PRIMARY KEY (`friendship_id`),
  UNIQUE KEY `unique_friendship` (`user1_id`,`user2_id`),
  KEY `user1_id` (`user1_id`),
  KEY `user2_id` (`user2_id`),
  KEY `status` (`status`),
  CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`user1_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  CONSTRAINT `friends_ibfk_2` FOREIGN KEY (`user2_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Таблица Groups

Хранит информацию о группах и их настройки.

```sql
CREATE TABLE `groups` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(100) NOT NULL,
  `group_description` text,
  `group_privacy` enum('public','closed','secret') NOT NULL DEFAULT 'public',
  `group_category` varchar(50) DEFAULT NULL,
  `group_cover` varchar(255) DEFAULT NULL,
  `group_picture` varchar(255) DEFAULT NULL,
  `group_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `group_updated` datetime DEFAULT NULL,
  `group_members` int(11) NOT NULL DEFAULT '0',
  `group_posts` int(11) NOT NULL DEFAULT '0',
  `group_admin` int(11) NOT NULL,
  `group_moderators` text,
  `group_settings` text,
  PRIMARY KEY (`group_id`),
  KEY `group_privacy` (`group_privacy`),
  KEY `group_category` (`group_category`),
  KEY `group_created` (`group_created`),
  KEY `group_admin` (`group_admin`),
  CONSTRAINT `groups_ibfk_1` FOREIGN KEY (`group_admin`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Таблица Group Members

Управляет членством в группах.

```sql
CREATE TABLE `group_members` (
  `membership_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `role` enum('admin','moderator','member') NOT NULL DEFAULT 'member',
  `joined` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('active','banned','left') NOT NULL DEFAULT 'active',
  PRIMARY KEY (`membership_id`),
  UNIQUE KEY `unique_membership` (`group_id`,`user_id`),
  KEY `group_id` (`group_id`),
  KEY `user_id` (`user_id`),
  KEY `role` (`role`),
  KEY `status` (`status`),
  CONSTRAINT `group_members_ibfk_1` FOREIGN KEY (`group_id`) REFERENCES `groups` (`group_id`) ON DELETE CASCADE,
  CONSTRAINT `group_members_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Таблица Messages

Хранит личные сообщения между пользователями.

```sql
CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `message_text` text,
  `message_media` text,
  `message_type` enum('text','photo','video','file','sticker') NOT NULL DEFAULT 'text',
  `message_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `message_read` tinyint(1) NOT NULL DEFAULT '0',
  `message_deleted` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`message_id`),
  KEY `conversation_id` (`conversation_id`),
  KEY `user_id` (`user_id`),
  KEY `message_created` (`message_created`),
  KEY `message_read` (`message_read`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`conversation_id`) ON DELETE CASCADE,
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Таблица Conversations

Управляет потоками бесед.

```sql
CREATE TABLE `conversations` (
  `conversation_id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_type` enum('user','group') NOT NULL DEFAULT 'user',
  `conversation_name` varchar(100) DEFAULT NULL,
  `conversation_picture` varchar(255) DEFAULT NULL,
  `conversation_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `conversation_updated` datetime DEFAULT NULL,
  `conversation_last_message` int(11) DEFAULT NULL,
  `conversation_participants` text,
  PRIMARY KEY (`conversation_id`),
  KEY `conversation_type` (`conversation_type`),
  KEY `conversation_created` (`conversation_created`),
  KEY `conversation_last_message` (`conversation_last_message`),
  CONSTRAINT `conversations_ibfk_1` FOREIGN KEY (`conversation_last_message`) REFERENCES `messages` (`message_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Таблица Notifications

Хранит уведомления пользователей.

```sql
CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `notification_type` varchar(50) NOT NULL,
  `notification_text` text NOT NULL,
  `notification_data` text,
  `notification_created` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `notification_read` tinyint(1) NOT NULL DEFAULT '0',
  `notification_action_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `user_id` (`user_id`),
  KEY `notification_type` (`notification_type`),
  KEY `notification_created` (`notification_created`),
  KEY `notification_read` (`notification_read`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

### Таблица System Settings

Хранит системные настройки.

```sql
CREATE TABLE `system_settings` (
  `setting_id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_name` varchar(100) NOT NULL,
  `setting_value` text,
  `setting_type` enum('string','number','boolean','json') NOT NULL DEFAULT 'string',
  `setting_category` varchar(50) DEFAULT NULL,
  `setting_updated` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`setting_id`),
  UNIQUE KEY `setting_name` (`setting_name`),
  KEY `setting_category` (`setting_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

## Индексы и производительность

### Основные индексы
- Все таблицы имеют первичные ключи на основных ID колонках
- Связи внешних ключей правильно проиндексированы
- Часто запрашиваемые колонки имеют специальные индексы

### Составные индексы
- `posts`: `(user_id, post_created)` для запросов ленты пользователя
- `comments`: `(post_id, comment_created)` для комментариев к постам
- `friends`: `(user1_id, status)` для запросов дружбы
- `messages`: `(conversation_id, message_created)` для истории бесед

### Полнотекстовые индексы
- `posts.post_text` для поиска контента
- `comments.comment_text` для поиска комментариев
- `users.user_biography` для поиска профилей пользователей

## Примеры запросов

### Частые запросы

#### Получить ленту пользователя
```sql
SELECT p.*, u.user_name, u.user_picture 
FROM posts p 
JOIN users u ON p.user_id = u.user_id 
WHERE p.user_id = ? 
ORDER BY p.post_created DESC 
LIMIT 20;
```

#### Получить друзей пользователя
```sql
SELECT u.* 
FROM users u 
JOIN friends f ON u.user_id = f.user2_id 
WHERE f.user1_id = ? AND f.status = 'accepted'
UNION
SELECT u.* 
FROM users u 
JOIN friends f ON u.user_id = f.user1_id 
WHERE f.user2_id = ? AND f.status = 'accepted';
```

#### Получить участников группы
```sql
SELECT u.*, gm.role, gm.joined 
FROM users u 
JOIN group_members gm ON u.user_id = gm.user_id 
WHERE gm.group_id = ? AND gm.status = 'active'
ORDER BY gm.role DESC, gm.joined ASC;
```

#### Получить непрочитанные уведомления
```sql
SELECT * 
FROM notifications 
WHERE user_id = ? AND notification_read = 0 
ORDER BY notification_created DESC;
```

#### Поиск постов
```sql
SELECT p.*, u.user_name, u.user_picture 
FROM posts p 
JOIN users u ON p.user_id = u.user_id 
WHERE MATCH(p.post_text) AGAINST(? IN NATURAL LANGUAGE MODE)
ORDER BY p.post_created DESC;
```

## Связи данных

### Связи один-ко-многим
- Пользователи → Посты
- Пользователи → Комментарии
- Пользователи → Сообщения
- Пользователи → Уведомления
- Группы → Участники групп
- Беседы → Сообщения

### Связи многие-ко-многим
- Пользователи ↔ Пользователи (Друзья)
- Пользователи ↔ Группы (Участники групп)

### Самоссылающиеся связи
- Комментарии → Комментарии (Ответы)

## Целостность данных

### Ограничения внешних ключей
- Все внешние ключи имеют правильные действия CASCADE или SET NULL
- Референтная целостность поддерживается во всех связях

### Ограничения проверки
- Значения enum обеспечивают согласованность данных
- Ограничения дат предотвращают недопустимые даты
- Ограничения длины предотвращают переполнение данных

### Триггеры
- Автоматические обновления временных меток
- Обновления счетчиков для лайков, комментариев, репостов
- Генерация уведомлений для важных событий

## Резервное копирование и восстановление

### Стратегия резервного копирования
- Ежедневные полные резервные копии
- Почасовые инкрементальные резервные копии
- Возможность восстановления на определенный момент времени

### Процедуры восстановления
- Восстановление базы данных из резервных копий
- Проверка целостности данных
- Шаги восстановления сервиса

## Мониторинг и обслуживание

### Мониторинг производительности
- Отслеживание времени выполнения запросов
- Анализ использования индексов
- Мониторинг размера таблиц

### Задачи обслуживания
- Регулярная оптимизация индексов
- Обновление статистики таблиц
- Ротация файлов логов

## Соображения безопасности

### Защита данных
- Шифрование чувствительных данных
- Реализация контроля доступа
- Ведение журналов аудита

### Предотвращение SQL-инъекций
- Использование подготовленных выражений
- Валидация входных данных
- Параметризованные запросы

## Миграция и версионирование

### Версионирование схемы
- Контроль версий для изменений схемы
- Скрипты миграции для обновлений
- Процедуры отката

### Миграция данных
- Безопасное преобразование данных
- Валидация мигрированных данных
- Процедуры тестирования

## Устранение неполадок

### Частые проблемы
- Узкие места производительности
- Разрешение взаимоблокировок
- Оптимизация индексов

### Диагностические запросы
- Проверки состояния системы
- Анализ производительности
- Расследование ошибок

## Лучшие практики

### Оптимизация запросов
- Использование подходящих индексов
- Избегание SELECT *
- Ограничение результирующих наборов

### Моделирование данных
- Адекватная нормализация
- Рассмотрение денормализации для производительности
- Планирование масштабируемости

### Обслуживание
- Регулярный мониторинг
- Проактивная оптимизация
- Обновление документации
