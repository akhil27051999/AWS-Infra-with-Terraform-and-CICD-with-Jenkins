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
        AWS_ACCOUNT_ID = "174350031850"
        AWS_REGION = "us-east-1"
        ECR_REPO = "jenkins-ecr-repo"
        IMAGE_TAG = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}:latest"
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
        
        stage('Install AWS CLI') {
            steps {
                sh '''
                    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
                    unzip awscliv2.zip
                    ./aws/install
                    aws --version
                '''
            }
        }

        stage('Login to AWS ECR') {
            steps {
                sh """
                    aws configure set default.region ${AWS_REGION}
                    aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'export DOCKER_BUILDKIT=1'
                    docker.build("${IMAGE_TAG}", ".")
                }
            }
        }

        stage('Push Docker Image to ECR') {
            steps {
                sh "docker push ${IMAGE_TAG}"
            }
        }

        stage('Run Container') {
            steps {
                script {
                    sh "docker stop ${CONTAINER_NAME} || true"
                    sh "docker rm ${CONTAINER_NAME} || true"
                    sh "docker run -d -p 5000:5000 --name ${CONTAINER_NAME} ${IMAGE_TAG}"
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
