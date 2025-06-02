pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    docker.build("my-app")
                }
            }
        }

        stage('Run Container') {
            steps {
                script {
                    sh 'docker run -d -p 5000:5000 --name my-app my-app'
                }
            }
        }
    }

    post {
        always {
            script {
                // Clean up container after build (optional)
                sh 'docker stop my-app || true'
                sh 'docker rm my-app || true'
            }
        }
    }
}
