pipeline {
    agent {
        docker {
            image 'node:18'
            args '-u root'  // optional: allows writing in workspace
        }
    }

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
                sh 'npm install'
                sh 'npm test'
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
