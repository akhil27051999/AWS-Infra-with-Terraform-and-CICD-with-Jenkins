pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-app"
        CONTAINER_NAME = "my-app"
        DOCKER_BUILDKIT = '1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Run Tests') {
            steps {
                script {
                    // Example: Node.js tests (replace for your app)
                    sh 'npm install'
                    sh 'npm test'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using BuildKit
                    sh 'export DOCKER_BUILDKIT=1'
                    docker.build("${IMAGE_NAME}", ".")
                }
            }
        }

        /*
        stage('Push to AWS ECR') {
            steps {
                script {
                    sh '''
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 174350031850.dkr.ecr.us-east-1.amazonaws.com
                    docker tag ${IMAGE_NAME}:latest 174350031850.dkr.ecr.us-east-1.amazonaws.com/${IMAGE_NAME}:latest
                    docker push 174350031850.dkr.ecr.us-east-1.amazonaws.com/${IMAGE_NAME}:latest
                    '''
                }
            }
        }
        */

        stage('Run Container') {
            steps {
                script {
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                    sh "docker run -d -p 5000:5000 --name ${CONTAINER_NAME} ${IMAGE_NAME}"
                }
            }
        }
    }

    post {
        always {
            script {
                // Ensure cleanup of container regardless of build result
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
            }
        }
    }
}
