pipeline {
    agent any

    environment {
        IMAGE_NAME = "my-app"
        CONTAINER_NAME = "my-app"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
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
            script {
                sh "docker stop ${CONTAINER_NAME} || true"
                sh "docker rm ${CONTAINER_NAME} || true"
            }
        }
    }
}
