# Конфигурации Docker

## Обзор

Этот документ содержит подробные конфигурации Docker для платформы REChain DAO, включая настройки для разработки, тестирования и продакшена.

## Содержание

1. [Конфигурации для разработки](#конфигурации-для-разработки)
2. [Конфигурации для тестирования](#конфигурации-для-тестирования)
3. [Конфигурации для продакшена](#конфигурации-для-продакшена)
4. [Безопасность и мониторинг](#безопасность-и-мониторинг)
5. [Логирование и отладка](#логирование-и-отладка)

## Конфигурации для разработки

### Docker Compose для разработки
```yaml
# docker-compose.dev.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "3000:3000"
      - "9229:9229"  # Порт для отладки
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - NODE_ENV=development
      - DEBUG=rechain-dao:*
    command: npm run dev
    depends_on:
      - mysql
      - redis
    networks:
      - rechain-network

  mysql:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=rechain_dao
      - MYSQL_USER=dev
      - MYSQL_PASSWORD=dev
    volumes:
      - mysql_data:/var/lib/mysql
      - ./docker/mysql/init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - rechain-network

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - rechain-network

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/nginx/nginx.dev.conf:/etc/nginx/nginx.conf
      - ./docker/nginx/ssl:/etc/nginx/ssl
    depends_on:
      - app
    networks:
      - rechain-network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    ports:
      - "8080:80"
    environment:
      - PMA_HOST=mysql
      - PMA_USER=dev
      - PMA_PASSWORD=dev
    depends_on:
      - mysql
    networks:
      - rechain-network

  redis-commander:
    image: rediscommander/redis-commander
    ports:
      - "8081:8081"
    environment:
      - REDIS_HOSTS=local:redis:6379
    depends_on:
      - redis
    networks:
      - rechain-network

volumes:
  mysql_data:
  redis_data:

networks:
  rechain-network:
    driver: bridge
```

### Dockerfile для разработки
```dockerfile
# Dockerfile.dev
FROM node:18-alpine

# Установка зависимостей
RUN apk add --no-cache \
    git \
    python3 \
    make \
    g++

# Создание рабочей директории
WORKDIR /app

# Копирование package.json и package-lock.json
COPY package*.json ./

# Установка зависимостей
RUN npm ci

# Копирование исходного кода
COPY . .

# Установка глобальных зависимостей для разработки
RUN npm install -g nodemon

# Открытие портов
EXPOSE 3000 9229

# Команда по умолчанию
CMD ["npm", "run", "dev"]
```

## Конфигурации для тестирования

### Docker Compose для тестирования
```yaml
# docker-compose.test.yml
version: '3.8'

services:
  app-test:
    build:
      context: .
      dockerfile: Dockerfile.test
    environment:
      - NODE_ENV=test
      - DB_HOST=mysql-test
      - DB_PORT=3306
      - DB_NAME=rechain_dao_test
      - DB_USER=test
      - DB_PASSWORD=test
      - REDIS_HOST=redis-test
      - REDIS_PORT=6379
    depends_on:
      - mysql-test
      - redis-test
    networks:
      - test-network

  mysql-test:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=rechain_dao_test
      - MYSQL_USER=test
      - MYSQL_PASSWORD=test
    volumes:
      - ./docker/mysql/test-init.sql:/docker-entrypoint-initdb.d/init.sql
    networks:
      - test-network

  redis-test:
    image: redis:7-alpine
    networks:
      - test-network

  test-runner:
    build:
      context: .
      dockerfile: Dockerfile.test
    command: npm run test:ci
    environment:
      - NODE_ENV=test
      - DB_HOST=mysql-test
      - DB_PORT=3306
      - DB_NAME=rechain_dao_test
      - DB_USER=test
      - DB_PASSWORD=test
      - REDIS_HOST=redis-test
      - REDIS_PORT=6379
    depends_on:
      - app-test
      - mysql-test
      - redis-test
    networks:
      - test-network

volumes:
  mysql_test_data:

networks:
  test-network:
    driver: bridge
```

### Dockerfile для тестирования
```dockerfile
# Dockerfile.test
FROM node:18-alpine

# Установка зависимостей
RUN apk add --no-cache \
    git \
    python3 \
    make \
    g++

# Создание рабочей директории
WORKDIR /app

# Копирование package.json и package-lock.json
COPY package*.json ./

# Установка зависимостей
RUN npm ci

# Копирование исходного кода
COPY . .

# Установка глобальных зависимостей для тестирования
RUN npm install -g jest

# Команда по умолчанию
CMD ["npm", "run", "test:ci"]
```

## Конфигурации для продакшена

### Docker Compose для продакшена
```yaml
# docker-compose.prod.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.prod
    ports:
      - "3000:3000"
    environment:
      - NODE_ENV=production
    volumes:
      - app_logs:/app/logs
    depends_on:
      - mysql
      - redis
    networks:
      - rechain-network
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M

  mysql:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
      - MYSQL_DATABASE=${DB_NAME}
      - MYSQL_USER=${DB_USER}
      - MYSQL_PASSWORD=${DB_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
      - ./docker/mysql/my.cnf:/etc/mysql/conf.d/my.cnf
    networks:
      - rechain-network
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 2G
        reservations:
          cpus: '0.5'
          memory: 1G

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
      - ./docker/redis/redis.conf:/usr/local/etc/redis/redis.conf
    networks:
      - rechain-network
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M

  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./docker/nginx/nginx.prod.conf:/etc/nginx/nginx.conf
      - ./docker/nginx/ssl:/etc/nginx/ssl
    depends_on:
      - app
    networks:
      - rechain-network
    restart: unless-stopped
    deploy:
      resources:
        limits:
          cpus: '0.5'
          memory: 256M
        reservations:
          cpus: '0.25'
          memory: 128M

  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./docker/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    networks:
      - rechain-network
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD}
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - rechain-network
    restart: unless-stopped

volumes:
  mysql_data:
  redis_data:
  app_logs:
  prometheus_data:
  grafana_data:

networks:
  rechain-network:
    driver: bridge
```

### Dockerfile для продакшена
```dockerfile
# Dockerfile.prod
FROM node:18-alpine AS builder

# Установка зависимостей для сборки
RUN apk add --no-cache \
    git \
    python3 \
    make \
    g++

# Создание рабочей директории
WORKDIR /app

# Копирование package.json и package-lock.json
COPY package*.json ./

# Установка зависимостей
RUN npm ci --only=production

# Копирование исходного кода
COPY . .

# Сборка приложения
RUN npm run build

# Продакшен образ
FROM node:18-alpine AS production

# Создание пользователя для безопасности
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001

# Создание рабочей директории
WORKDIR /app

# Копирование зависимостей
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package*.json ./

# Создание директории для логов
RUN mkdir -p /app/logs

# Установка прав доступа
RUN chown -R nextjs:nodejs /app
USER nextjs

# Открытие портов
EXPOSE 3000

# Команда по умолчанию
CMD ["npm", "start"]
```

## Безопасность и мониторинг

### Конфигурация безопасности
```yaml
# docker-compose.security.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.prod
    environment:
      - NODE_ENV=production
    volumes:
      - app_logs:/app/logs
    networks:
      - rechain-network
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    read_only: true
    tmpfs:
      - /tmp
      - /var/run
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
      - SETGID
      - SETUID

  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
      - MYSQL_DATABASE=${DB_NAME}
      - MYSQL_USER=${DB_USER}
      - MYSQL_PASSWORD=${DB_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - rechain-network
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    read_only: true
    tmpfs:
      - /tmp
      - /var/run

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    networks:
      - rechain-network
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    read_only: true
    tmpfs:
      - /tmp
      - /var/run

  nginx:
    image: nginx:alpine
    volumes:
      - ./docker/nginx/nginx.prod.conf:/etc/nginx/nginx.conf
      - ./docker/nginx/ssl:/etc/nginx/ssl
    networks:
      - rechain-network
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    read_only: true
    tmpfs:
      - /tmp
      - /var/run

volumes:
  mysql_data:
  redis_data:
  app_logs:

networks:
  rechain-network:
    driver: bridge
```

### Мониторинг контейнеров
```yaml
# docker-compose.monitoring.yml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./docker/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
    networks:
      - rechain-network
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=${GRAFANA_PASSWORD}
    volumes:
      - grafana_data:/var/lib/grafana
    networks:
      - rechain-network
    restart: unless-stopped

  node-exporter:
    image: prom/node-exporter:latest
    ports:
      - "9100:9100"
    volumes:
      - /proc:/host/proc:ro
      - /sys:/host/sys:ro
      - /:/rootfs:ro
    networks:
      - rechain-network
    restart: unless-stopped

  cadvisor:
    image: gcr.io/cadvisor/cadvisor:latest
    ports:
      - "8080:8080"
    volumes:
      - /:/rootfs:ro
      - /var/run:/var/run:ro
      - /sys:/sys:ro
      - /var/lib/docker:/var/lib/docker:ro
      - /dev/disk/:/dev/disk:ro
    networks:
      - rechain-network
    restart: unless-stopped

volumes:
  prometheus_data:
  grafana_data:

networks:
  rechain-network:
    driver: bridge
```

## Логирование и отладка

### Конфигурация логирования
```yaml
# docker-compose.logging.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.prod
    environment:
      - NODE_ENV=production
    volumes:
      - app_logs:/app/logs
    networks:
      - rechain-network
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  mysql:
    image: mysql:8.0
    environment:
      - MYSQL_ROOT_PASSWORD=${DB_ROOT_PASSWORD}
      - MYSQL_DATABASE=${DB_NAME}
      - MYSQL_USER=${DB_USER}
      - MYSQL_PASSWORD=${DB_PASSWORD}
    volumes:
      - mysql_data:/var/lib/mysql
    networks:
      - rechain-network
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  redis:
    image: redis:7-alpine
    volumes:
      - redis_data:/data
    networks:
      - rechain-network
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  nginx:
    image: nginx:alpine
    volumes:
      - ./docker/nginx/nginx.prod.conf:/etc/nginx/nginx.conf
      - ./docker/nginx/ssl:/etc/nginx/ssl
    networks:
      - rechain-network
    restart: unless-stopped
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"

  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:8.8.0
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
    volumes:
      - elasticsearch_data:/usr/share/elasticsearch/data
    networks:
      - rechain-network
    restart: unless-stopped

  logstash:
    image: docker.elastic.co/logstash/logstash:8.8.0
    volumes:
      - ./docker/logstash/logstash.conf:/usr/share/logstash/pipeline/logstash.conf
    networks:
      - rechain-network
    restart: unless-stopped
    depends_on:
      - elasticsearch

  kibana:
    image: docker.elastic.co/kibana/kibana:8.8.0
    ports:
      - "5601:5601"
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    networks:
      - rechain-network
    restart: unless-stopped
    depends_on:
      - elasticsearch

volumes:
  mysql_data:
  redis_data:
  app_logs:
  elasticsearch_data:

networks:
  rechain-network:
    driver: bridge
```

### Скрипты для управления
```bash
#!/bin/bash
# docker-manager.sh

# Функции для управления Docker контейнерами

start_dev() {
    echo "Запуск среды разработки..."
    docker-compose -f docker-compose.dev.yml up -d
    echo "Среда разработки запущена!"
    echo "Приложение: http://localhost:3000"
    echo "PhpMyAdmin: http://localhost:8080"
    echo "Redis Commander: http://localhost:8081"
}

stop_dev() {
    echo "Остановка среды разработки..."
    docker-compose -f docker-compose.dev.yml down
    echo "Среда разработки остановлена!"
}

start_prod() {
    echo "Запуск продакшен среды..."
    docker-compose -f docker-compose.prod.yml up -d
    echo "Продакшен среда запущена!"
    echo "Приложение: http://localhost:3000"
    echo "Prometheus: http://localhost:9090"
    echo "Grafana: http://localhost:3001"
}

stop_prod() {
    echo "Остановка продакшен среды..."
    docker-compose -f docker-compose.prod.yml down
    echo "Продакшен среда остановлена!"
}

start_monitoring() {
    echo "Запуск мониторинга..."
    docker-compose -f docker-compose.monitoring.yml up -d
    echo "Мониторинг запущен!"
    echo "Prometheus: http://localhost:9090"
    echo "Grafana: http://localhost:3001"
}

stop_monitoring() {
    echo "Остановка мониторинга..."
    docker-compose -f docker-compose.monitoring.yml down
    echo "Мониторинг остановлен!"
}

start_logging() {
    echo "Запуск системы логирования..."
    docker-compose -f docker-compose.logging.yml up -d
    echo "Система логирования запущена!"
    echo "Kibana: http://localhost:5601"
}

stop_logging() {
    echo "Остановка системы логирования..."
    docker-compose -f docker-compose.logging.yml down
    echo "Система логирования остановлена!"
}

# Обработка аргументов командной строки
case "$1" in
    "dev")
        start_dev
        ;;
    "prod")
        start_prod
        ;;
    "monitoring")
        start_monitoring
        ;;
    "logging")
        start_logging
        ;;
    "stop-dev")
        stop_dev
        ;;
    "stop-prod")
        stop_prod
        ;;
    "stop-monitoring")
        stop_monitoring
        ;;
    "stop-logging")
        stop_logging
        ;;
    *)
        echo "Использование: $0 {dev|prod|monitoring|logging|stop-dev|stop-prod|stop-monitoring|stop-logging}"
        echo ""
        echo "Команды:"
        echo "  dev          - Запуск среды разработки"
        echo "  prod         - Запуск продакшен среды"
        echo "  monitoring   - Запуск мониторинга"
        echo "  logging      - Запуск системы логирования"
        echo "  stop-dev     - Остановка среды разработки"
        echo "  stop-prod    - Остановка продакшен среды"
        echo "  stop-monitoring - Остановка мониторинга"
        echo "  stop-logging - Остановка системы логирования"
        exit 1
        ;;
esac
```

## Заключение

Эти конфигурации Docker обеспечивают полную настройку среды разработки, тестирования и продакшена для платформы REChain DAO. Они включают безопасность, мониторинг и логирование для обеспечения надежной работы системы.

Помните: Регулярно обновляйте Docker образы и конфигурации для обеспечения безопасности и производительности. Используйте мониторинг для отслеживания состояния контейнеров и системы в целом.
