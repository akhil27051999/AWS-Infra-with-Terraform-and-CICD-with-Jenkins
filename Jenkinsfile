pipeline {
    agent {
        docker {
            image 'node:18'
            args '-u root -v /var/run/docker.sock:/var/run/docker.sock'
        }
    }

    environment {
        IMAGE_NAME = "my-app"
        CONTAINER_NAME = "my-app"
        DOCKER_BUILDKIT = '1'
        AWS_ACCOUNT_ID = "174350031850"
        AWS_REGION = "us-east-1"
        ECR_REPO_NAME = "jenkins-ecr-repo"
        ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO_NAME}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Run Tests') {
            steps {
                sh 'npm install'
                sh 'npm test'
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh '''
                    aws --version
                    aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URI
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'export DOCKER_BUILDKIT=1'
                    docker.build("${IMAGE_NAME}", ".")
                }
            }
        }

        stage('Tag & Push Docker Image to ECR') {
            steps {
                script {
                    sh """
                        docker tag ${IMAGE_NAME}:latest ${ECR_URI}:latest
                        docker push ${ECR_URI}:latest
                    """
                }
            }
        }

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
            sh "docker stop ${CONTAINER_NAME} || true"
            sh "docker rm ${CONTAINER_NAME} || true"
        }
    }
}
