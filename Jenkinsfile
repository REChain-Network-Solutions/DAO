pipeline {
    agent any
    
    environment {
        NODE_VERSION = '18'
        DOCKER_REGISTRY = 'your-registry.com'
        IMAGE_NAME = 'rechain-dao'
        KUBECONFIG = credentials('kubeconfig')
        DB_PASSWORD = credentials('db-password')
        REDIS_PASSWORD = credentials('redis-password')
    }
    
    options {
        timeout(time: 30, unit: 'MINUTES')
        timestamps()
        ansiColor('xterm')
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                script {
                    env.GIT_COMMIT_SHORT = sh(
                        script: 'git rev-parse --short HEAD',
                        returnStdout: true
                    ).trim()
                    env.BUILD_TAG = "${env.BUILD_NUMBER}-${env.GIT_COMMIT_SHORT}"
                }
            }
        }
        
        stage('Setup') {
            steps {
                sh '''
                    echo "Setting up build environment..."
                    node --version
                    npm --version
                    docker --version
                    kubectl version --client
                '''
            }
        }
        
        stage('Install Dependencies') {
            steps {
                sh '''
                    echo "Installing dependencies..."
                    npm ci --prefer-offline --no-audit
                '''
            }
        }
        
        stage('Lint & Type Check') {
            parallel {
                stage('ESLint') {
                    steps {
                        sh 'npm run lint'
                    }
                }
                stage('TypeScript') {
                    steps {
                        sh 'npm run type-check'
                    }
                }
                stage('Prettier') {
                    steps {
                        sh 'npm run format:check'
                    }
                }
            }
        }
        
        stage('Unit Tests') {
            steps {
                sh '''
                    echo "Running unit tests..."
                    npm run test:unit -- --coverage --watchAll=false
                '''
            }
            post {
                always {
                    publishTestResults testResultsPattern: 'test-results.xml'
                    publishCoverage adapters: [
                        coberturaAdapter('coverage/cobertura-coverage.xml')
                    ], sourceFileResolver: sourceFiles('STORE_LAST_BUILD')
                }
            }
        }
        
        stage('Integration Tests') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                    changeRequest()
                }
            }
            steps {
                sh '''
                    echo "Starting integration tests..."
                    docker-compose -f docker-compose.test.yml up -d
                    sleep 30
                    npm run test:integration
                '''
            }
            post {
                always {
                    sh 'docker-compose -f docker-compose.test.yml down -v'
                }
            }
        }
        
        stage('Security Scan') {
            steps {
                sh '''
                    echo "Running security scans..."
                    npm audit --audit-level moderate
                    npm run security:scan
                '''
            }
        }
        
        stage('Build Application') {
            steps {
                sh '''
                    echo "Building application..."
                    npm run build
                    echo "Build completed successfully"
                '''
            }
        }
        
        stage('Build Docker Image') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                    changeRequest()
                }
            }
            steps {
                script {
                    def imageTag = "${env.DOCKER_REGISTRY}/${env.IMAGE_NAME}:${env.BUILD_TAG}"
                    def latestTag = "${env.DOCKER_REGISTRY}/${env.IMAGE_NAME}:latest"
                    
                    sh """
                        echo "Building Docker image..."
                        docker build -t ${imageTag} -t ${latestTag} .
                        echo "Docker image built: ${imageTag}"
                    """
                    
                    env.DOCKER_IMAGE = imageTag
                }
            }
        }
        
        stage('Push Docker Image') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                }
            }
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'docker-registry', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh '''
                            echo "Logging into Docker registry..."
                            echo $DOCKER_PASS | docker login $DOCKER_REGISTRY -u $DOCKER_USER --password-stdin
                            
                            echo "Pushing Docker images..."
                            docker push $DOCKER_IMAGE
                            docker push $DOCKER_REGISTRY/$IMAGE_NAME:latest
                        '''
                    }
                }
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                script {
                    sh '''
                        echo "Deploying to staging environment..."
                        kubectl config use-context staging
                        kubectl set image deployment/rechain-dao-app rechain-dao-app=$DOCKER_IMAGE -n rechain-dao-staging
                        kubectl rollout status deployment/rechain-dao-app -n rechain-dao-staging --timeout=300s
                    '''
                }
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'main'
            }
            steps {
                script {
                    sh '''
                        echo "Deploying to production environment..."
                        kubectl config use-context production
                        kubectl set image deployment/rechain-dao-app rechain-dao-app=$DOCKER_IMAGE -n rechain-dao
                        kubectl rollout status deployment/rechain-dao-app -n rechain-dao --timeout=600s
                    '''
                }
            }
        }
        
        stage('Run E2E Tests') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    echo "Running E2E tests against production..."
                    npm run test:e2e:production
                '''
            }
            post {
                always {
                    publishTestResults testResultsPattern: 'e2e-results.xml'
                }
            }
        }
    }
    
    post {
        always {
            sh '''
                echo "Cleaning up workspace..."
                docker system prune -f
                npm cache clean --force
            '''
        }
        
        success {
            script {
                if (env.BRANCH_NAME == 'main') {
                    slackSend(
                        channel: '#deployments',
                        color: 'good',
                        message: "✅ Production deployment successful!\n" +
                                "Build: ${env.BUILD_NUMBER}\n" +
                                "Commit: ${env.GIT_COMMIT_SHORT}\n" +
                                "Image: ${env.DOCKER_IMAGE}"
                    )
                } else if (env.BRANCH_NAME == 'develop') {
                    slackSend(
                        channel: '#deployments',
                        color: 'warning',
                        message: "🚀 Staging deployment successful!\n" +
                                "Build: ${env.BUILD_NUMBER}\n" +
                                "Commit: ${env.GIT_COMMIT_SHORT}\n" +
                                "Image: ${env.DOCKER_IMAGE}"
                    )
                }
            }
        }
        
        failure {
            script {
                slackSend(
                    channel: '#deployments',
                    color: 'danger',
                    message: "❌ Build failed!\n" +
                            "Build: ${env.BUILD_NUMBER}\n" +
                            "Branch: ${env.BRANCH_NAME}\n" +
                            "Commit: ${env.GIT_COMMIT_SHORT}\n" +
                            "Console: ${env.BUILD_URL}console"
                )
            }
        }
        
        unstable {
            script {
                slackSend(
                    channel: '#deployments',
                    color: 'warning',
                    message: "⚠️ Build unstable!\n" +
                            "Build: ${env.BUILD_NUMBER}\n" +
                            "Branch: ${env.BRANCH_NAME}\n" +
                            "Console: ${env.BUILD_URL}console"
                )
            }
        }
    }
}
