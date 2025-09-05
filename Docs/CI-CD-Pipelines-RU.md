# CI/CD Пайплайны

## Обзор

Этот документ содержит подробные конфигурации CI/CD пайплайнов для платформы REChain DAO, включая GitHub Actions, GitLab CI, Jenkins и автоматизацию развертывания.

## Содержание

1. [GitHub Actions](#github-actions)
2. [GitLab CI](#gitlab-ci)
3. [Jenkins](#jenkins)
4. [Автоматизация развертывания](#автоматизация-развертывания)
5. [Мониторинг и уведомления](#мониторинг-и-уведомления)

## GitHub Actions

### Основной пайплайн
```yaml
# .github/workflows/ci-cd.yml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

env:
  NODE_VERSION: '18'
  REGISTRY: ghcr.io
  IMAGE_NAME: ${{ github.repository }}

jobs:
  test:
    name: Тестирование
    runs-on: ubuntu-latest
    
    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: rechain_dao_test
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
        ports:
          - 3306:3306
      
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd="redis-cli ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
        ports:
          - 6379:6379

    steps:
    - name: Проверка кода
      uses: actions/checkout@v4

    - name: Настройка Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'

    - name: Установка зависимостей
      run: npm ci

    - name: Линтинг кода
      run: npm run lint

    - name: Проверка типов
      run: npm run type-check

    - name: Unit тесты
      run: npm run test:unit
      env:
        DB_HOST: localhost
        DB_PORT: 3306
        DB_NAME: rechain_dao_test
        DB_USER: root
        DB_PASSWORD: root
        REDIS_HOST: localhost
        REDIS_PORT: 6379

    - name: Интеграционные тесты
      run: npm run test:integration
      env:
        DB_HOST: localhost
        DB_PORT: 3306
        DB_NAME: rechain_dao_test
        DB_USER: root
        DB_PASSWORD: root
        REDIS_HOST: localhost
        REDIS_PORT: 6379

    - name: Загрузка покрытия кода
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info

  build:
    name: Сборка
    runs-on: ubuntu-latest
    needs: test
    if: github.event_name == 'push'

    steps:
    - name: Проверка кода
      uses: actions/checkout@v4

    - name: Настройка Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'

    - name: Установка зависимостей
      run: npm ci

    - name: Сборка приложения
      run: npm run build

    - name: Создание артефактов
      run: |
        mkdir -p artifacts
        cp -r dist artifacts/
        cp package*.json artifacts/
        tar -czf artifacts.tar.gz artifacts/

    - name: Загрузка артефактов
      uses: actions/upload-artifact@v3
      with:
        name: build-artifacts
        path: artifacts.tar.gz

  docker:
    name: Docker образ
    runs-on: ubuntu-latest
    needs: test
    if: github.event_name == 'push'

    steps:
    - name: Проверка кода
      uses: actions/checkout@v4

    - name: Настройка Docker Buildx
      uses: docker/setup-buildx-action@v3

    - name: Вход в реестр
      uses: docker/login-action@v3
      with:
        registry: ${{ env.REGISTRY }}
        username: ${{ github.actor }}
        password: ${{ secrets.GITHUB_TOKEN }}

    - name: Извлечение метаданных
      id: meta
      uses: docker/metadata-action@v5
      with:
        images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}
        tags: |
          type=ref,event=branch
          type=ref,event=pr
          type=sha,prefix={{branch}}-
          type=raw,value=latest,enable={{is_default_branch}}

    - name: Сборка и отправка Docker образа
      uses: docker/build-push-action@v5
      with:
        context: .
        push: true
        tags: ${{ steps.meta.outputs.tags }}
        labels: ${{ steps.meta.outputs.labels }}
        cache-from: type=gha
        cache-to: type=gha,mode=max

  security:
    name: Безопасность
    runs-on: ubuntu-latest
    needs: test

    steps:
    - name: Проверка кода
      uses: actions/checkout@v4

    - name: Настройка Node.js
      uses: actions/setup-node@v4
      with:
        node-version: ${{ env.NODE_VERSION }}
        cache: 'npm'

    - name: Установка зависимостей
      run: npm ci

    - name: Аудит безопасности
      run: npm audit --audit-level moderate

    - name: Сканирование зависимостей
      uses: actions/dependency-review-action@v3
      if: github.event_name == 'pull_request'

    - name: Сканирование кода
      uses: github/super-linter@v4
      env:
        DEFAULT_BRANCH: main
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}

  deploy-staging:
    name: Развертывание в staging
    runs-on: ubuntu-latest
    needs: [build, docker, security]
    if: github.ref == 'refs/heads/develop'

    environment: staging

    steps:
    - name: Проверка кода
      uses: actions/checkout@v4

    - name: Настройка kubectl
      uses: azure/setup-kubectl@v3
      with:
        version: 'latest'

    - name: Настройка kubeconfig
      run: |
        echo "${{ secrets.KUBE_CONFIG_STAGING }}" | base64 -d > kubeconfig
        export KUBECONFIG=kubeconfig

    - name: Развертывание в staging
      run: |
        kubectl apply -f k8s/staging/
        kubectl set image deployment/rechain-dao-app rechain-dao-app=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:develop

    - name: Ожидание развертывания
      run: |
        kubectl rollout status deployment/rechain-dao-app -n rechain-dao-staging --timeout=300s

    - name: Проверка здоровья
      run: |
        kubectl get pods -n rechain-dao-staging
        kubectl get services -n rechain-dao-staging

  deploy-production:
    name: Развертывание в production
    runs-on: ubuntu-latest
    needs: [build, docker, security]
    if: github.ref == 'refs/heads/main'

    environment: production

    steps:
    - name: Проверка кода
      uses: actions/checkout@v4

    - name: Настройка kubectl
      uses: azure/setup-kubectl@v3
      with:
        version: 'latest'

    - name: Настройка kubeconfig
      run: |
        echo "${{ secrets.KUBE_CONFIG_PRODUCTION }}" | base64 -d > kubeconfig
        export KUBECONFIG=kubeconfig

    - name: Развертывание в production
      run: |
        kubectl apply -f k8s/production/
        kubectl set image deployment/rechain-dao-app rechain-dao-app=${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}:main

    - name: Ожидание развертывания
      run: |
        kubectl rollout status deployment/rechain-dao-app -n rechain-dao --timeout=600s

    - name: Проверка здоровья
      run: |
        kubectl get pods -n rechain-dao
        kubectl get services -n rechain-dao

    - name: Уведомление о развертывании
      uses: 8398a7/action-slack@v3
      with:
        status: success
        text: 'Развертывание в production завершено успешно!'
      env:
        SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### Пайплайн для тестирования
```yaml
# .github/workflows/test.yml
name: Тестирование

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  unit-tests:
    name: Unit тесты
    runs-on: ubuntu-latest

    steps:
    - name: Проверка кода
      uses: actions/checkout@v4

    - name: Настройка Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'

    - name: Установка зависимостей
      run: npm ci

    - name: Unit тесты
      run: npm run test:unit

    - name: Загрузка покрытия
      uses: codecov/codecov-action@v3
      with:
        file: ./coverage/lcov.info

  integration-tests:
    name: Интеграционные тесты
    runs-on: ubuntu-latest

    services:
      mysql:
        image: mysql:8.0
        env:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_DATABASE: rechain_dao_test
        options: >-
          --health-cmd="mysqladmin ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
        ports:
          - 3306:3306
      
      redis:
        image: redis:7-alpine
        options: >-
          --health-cmd="redis-cli ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=3
        ports:
          - 6379:6379

    steps:
    - name: Проверка кода
      uses: actions/checkout@v4

    - name: Настройка Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'

    - name: Установка зависимостей
      run: npm ci

    - name: Миграции базы данных
      run: npm run db:migrate
      env:
        DB_HOST: localhost
        DB_PORT: 3306
        DB_NAME: rechain_dao_test
        DB_USER: root
        DB_PASSWORD: root

    - name: Интеграционные тесты
      run: npm run test:integration
      env:
        DB_HOST: localhost
        DB_PORT: 3306
        DB_NAME: rechain_dao_test
        DB_USER: root
        DB_PASSWORD: root
        REDIS_HOST: localhost
        REDIS_PORT: 6379

  e2e-tests:
    name: E2E тесты
    runs-on: ubuntu-latest

    steps:
    - name: Проверка кода
      uses: actions/checkout@v4

    - name: Настройка Node.js
      uses: actions/setup-node@v4
      with:
        node-version: '18'
        cache: 'npm'

    - name: Установка зависимостей
      run: npm ci

    - name: Сборка приложения
      run: npm run build

    - name: Запуск приложения
      run: |
        npm start &
        sleep 30

    - name: E2E тесты
      run: npm run test:e2e
      env:
        CYPRESS_baseUrl: http://localhost:3000

    - name: Загрузка скриншотов
      uses: actions/upload-artifact@v3
      if: failure()
      with:
        name: cypress-screenshots
        path: cypress/screenshots

    - name: Загрузка видео
      uses: actions/upload-artifact@v3
      if: failure()
      with:
        name: cypress-videos
        path: cypress/videos
```

## GitLab CI

### Основной пайплайн
```yaml
# .gitlab-ci.yml
stages:
  - test
  - build
  - security
  - deploy

variables:
  NODE_VERSION: "18"
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

# Кэширование
cache:
  paths:
    - node_modules/
    - .npm/

# Тестирование
unit-tests:
  stage: test
  image: node:18-alpine
  script:
    - npm ci
    - npm run lint
    - npm run type-check
    - npm run test:unit
  coverage: '/Lines\s*:\s*(\d+\.\d+)%/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
    paths:
      - coverage/
    expire_in: 1 week

integration-tests:
  stage: test
  image: node:18-alpine
  services:
    - name: mysql:8.0
      alias: mysql
      variables:
        MYSQL_ROOT_PASSWORD: root
        MYSQL_DATABASE: rechain_dao_test
    - name: redis:7-alpine
      alias: redis
  script:
    - npm ci
    - npm run db:migrate
    - npm run test:integration
  variables:
    DB_HOST: mysql
    DB_PORT: 3306
    DB_NAME: rechain_dao_test
    DB_USER: root
    DB_PASSWORD: root
    REDIS_HOST: redis
    REDIS_PORT: 6379

e2e-tests:
  stage: test
  image: cypress/included:12.0.0
  script:
    - npm ci
    - npm run build
    - npm start &
    - sleep 30
    - npm run test:e2e
  artifacts:
    when: always
    paths:
      - cypress/screenshots/
      - cypress/videos/
    expire_in: 1 week

# Сборка
build:
  stage: build
  image: node:18-alpine
  script:
    - npm ci
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 week

# Docker образ
docker-build:
  stage: build
  image: docker:20.10.16
  services:
    - docker:20.10.16-dind
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - docker tag $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA $CI_REGISTRY_IMAGE:latest
    - docker push $CI_REGISTRY_IMAGE:latest
  only:
    - main
    - develop

# Безопасность
security-scan:
  stage: security
  image: node:18-alpine
  script:
    - npm ci
    - npm audit --audit-level moderate
    - npm run security:scan
  allow_failure: true

# Развертывание в staging
deploy-staging:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl config use-context staging
    - kubectl apply -f k8s/staging/
    - kubectl set image deployment/rechain-dao-app rechain-dao-app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - kubectl rollout status deployment/rechain-dao-app -n rechain-dao-staging
  environment:
    name: staging
    url: https://staging.rechain-dao.com
  only:
    - develop

# Развертывание в production
deploy-production:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl config use-context production
    - kubectl apply -f k8s/production/
    - kubectl set image deployment/rechain-dao-app rechain-dao-app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - kubectl rollout status deployment/rechain-dao-app -n rechain-dao
  environment:
    name: production
    url: https://rechain-dao.com
  only:
    - main
  when: manual
```

## Jenkins

### Jenkinsfile
```groovy
// Jenkinsfile
pipeline {
    agent any
    
    environment {
        NODE_VERSION = '18'
        DOCKER_REGISTRY = 'your-registry.com'
        IMAGE_NAME = 'rechain-dao'
    }
    
    stages {
        stage('Проверка кода') {
            steps {
                checkout scm
                sh 'npm ci'
                sh 'npm run lint'
                sh 'npm run type-check'
            }
        }
        
        stage('Unit тесты') {
            steps {
                sh 'npm run test:unit'
            }
            post {
                always {
                    publishHTML([
                        allowMissing: false,
                        alwaysLinkToLastBuild: true,
                        keepAll: true,
                        reportDir: 'coverage',
                        reportFiles: 'index.html',
                        reportName: 'Coverage Report'
                    ])
                }
            }
        }
        
        stage('Интеграционные тесты') {
            steps {
                sh 'npm run test:integration'
            }
        }
        
        stage('E2E тесты') {
            steps {
                sh 'npm run build'
                sh 'npm start &'
                sh 'sleep 30'
                sh 'npm run test:e2e'
            }
            post {
                always {
                    archiveArtifacts artifacts: 'cypress/screenshots/**', fingerprint: true
                    archiveArtifacts artifacts: 'cypress/videos/**', fingerprint: true
                }
            }
        }
        
        stage('Сборка Docker образа') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                }
            }
            steps {
                script {
                    def image = docker.build("${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}")
                    docker.withRegistry("https://${DOCKER_REGISTRY}", 'docker-registry-credentials') {
                        image.push()
                        image.push('latest')
                    }
                }
            }
        }
        
        stage('Развертывание в staging') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    sh """
                        kubectl config use-context staging
                        kubectl apply -f k8s/staging/
                        kubectl set image deployment/rechain-dao-app rechain-dao-app=${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}
                        kubectl rollout status deployment/rechain-dao-app -n rechain-dao-staging
                    """
                }
            }
        }
        
        stage('Развертывание в production') {
            when {
                branch 'main'
            }
            steps {
                input message: 'Развернуть в production?', ok: 'Да'
                script {
                    sh """
                        kubectl config use-context production
                        kubectl apply -f k8s/production/
                        kubectl set image deployment/rechain-dao-app rechain-dao-app=${DOCKER_REGISTRY}/${IMAGE_NAME}:${env.BUILD_NUMBER}
                        kubectl rollout status deployment/rechain-dao-app -n rechain-dao
                    """
                }
            }
        }
    }
    
    post {
        always {
            cleanWs()
        }
        success {
            slackSend channel: '#deployments', color: 'good', message: "✅ Развертывание успешно завершено: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        }
        failure {
            slackSend channel: '#deployments', color: 'danger', message: "❌ Развертывание не удалось: ${env.JOB_NAME} #${env.BUILD_NUMBER}"
        }
    }
}
```

## Автоматизация развертывания

### Скрипт развертывания
```bash
#!/bin/bash
# deploy.sh

set -e

# Конфигурация
ENVIRONMENT=$1
VERSION=$2
NAMESPACE="rechain-dao-$ENVIRONMENT"

if [ -z "$ENVIRONMENT" ] || [ -z "$VERSION" ]; then
    echo "Использование: $0 <environment> <version>"
    echo "Пример: $0 staging v1.2.3"
    exit 1
fi

echo "Развертывание версии $VERSION в $ENVIRONMENT..."

# Проверка подключения к кластеру
kubectl cluster-info

# Применение манифестов
echo "Применение манифестов Kubernetes..."
kubectl apply -f k8s/$ENVIRONMENT/

# Обновление образа
echo "Обновление образа приложения..."
kubectl set image deployment/rechain-dao-app rechain-dao-app=your-registry.com/rechain-dao:$VERSION -n $NAMESPACE

# Ожидание развертывания
echo "Ожидание завершения развертывания..."
kubectl rollout status deployment/rechain-dao-app -n $NAMESPACE --timeout=600s

# Проверка здоровья
echo "Проверка здоровья приложения..."
kubectl get pods -n $NAMESPACE
kubectl get services -n $NAMESPACE

# Проверка эндпоинтов
echo "Проверка эндпоинтов..."
kubectl get ingress -n $NAMESPACE

echo "Развертывание завершено успешно!"
```

### Скрипт отката
```bash
#!/bin/bash
# rollback.sh

set -e

# Конфигурация
ENVIRONMENT=$1
NAMESPACE="rechain-dao-$ENVIRONMENT"

if [ -z "$ENVIRONMENT" ]; then
    echo "Использование: $0 <environment>"
    echo "Пример: $0 staging"
    exit 1
fi

echo "Откат развертывания в $ENVIRONMENT..."

# Проверка подключения к кластеру
kubectl cluster-info

# Откат развертывания
echo "Откат развертывания..."
kubectl rollout undo deployment/rechain-dao-app -n $NAMESPACE

# Ожидание отката
echo "Ожидание завершения отката..."
kubectl rollout status deployment/rechain-dao-app -n $NAMESPACE --timeout=300s

# Проверка здоровья
echo "Проверка здоровья приложения..."
kubectl get pods -n $NAMESPACE

echo "Откат завершен успешно!"
```

## Мониторинг и уведомления

### Конфигурация уведомлений
```yaml
# notifications.yml
slack:
  webhook_url: ${SLACK_WEBHOOK_URL}
  channels:
    deployments: "#deployments"
    alerts: "#alerts"
    general: "#general"

email:
  smtp:
    host: smtp.gmail.com
    port: 587
    username: ${EMAIL_USERNAME}
    password: ${EMAIL_PASSWORD}
  recipients:
    - admin@rechain-dao.com
    - devops@rechain-dao.com

teams:
  webhook_url: ${TEAMS_WEBHOOK_URL}
  channels:
    deployments: "Deployments"
    alerts: "Alerts"
```

### Скрипт уведомлений
```bash
#!/bin/bash
# notify.sh

# Функция отправки уведомления в Slack
send_slack_notification() {
    local message=$1
    local color=$2
    local channel=${3:-"#general"}
    
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"$message\", \"color\":\"$color\"}" \
        $SLACK_WEBHOOK_URL
}

# Функция отправки email
send_email_notification() {
    local subject=$1
    local body=$2
    local recipients=$3
    
    echo "$body" | mail -s "$subject" $recipients
}

# Функция отправки уведомления в Teams
send_teams_notification() {
    local message=$1
    local color=$2
    
    curl -X POST -H 'Content-type: application/json' \
        --data "{\"text\":\"$message\", \"themeColor\":\"$color\"}" \
        $TEAMS_WEBHOOK_URL
}

# Основная функция
main() {
    local status=$1
    local environment=$2
    local version=$3
    local message=$4
    
    case $status in
        "success")
            send_slack_notification "✅ $message" "good" "#deployments"
            send_email_notification "Развертывание успешно" "$message" "admin@rechain-dao.com"
            send_teams_notification "✅ $message" "00ff00"
            ;;
        "failure")
            send_slack_notification "❌ $message" "danger" "#alerts"
            send_email_notification "Ошибка развертывания" "$message" "admin@rechain-dao.com,devops@rechain-dao.com"
            send_teams_notification "❌ $message" "ff0000"
            ;;
        "warning")
            send_slack_notification "⚠️ $message" "warning" "#alerts"
            send_email_notification "Предупреждение" "$message" "admin@rechain-dao.com"
            send_teams_notification "⚠️ $message" "ffff00"
            ;;
    esac
}

# Вызов основной функции
main "$@"
```

## Заключение

Эти CI/CD пайплайны обеспечивают автоматизированное тестирование, сборку и развертывание платформы REChain DAO. Они включают мониторинг, уведомления и процедуры отката для обеспечения надежности развертывания.

Помните: Регулярно обновляйте пайплайны в соответствии с изменениями в приложении и инфраструктуре. Мониторьте производительность пайплайнов и оптимизируйте их для ускорения развертывания.
