pipeline {
    agent any
    environment {
        DOCKER_HUB_USER = credentials('docker-hub-username')
        DOCKER_HUB_PASS = credentials('docker-hub-password')
    }
    stages {
       stage('Clone du Projet') {
            steps {
                git branch: 'main', url: 'https://github.com/manalbctt/React-Quiz-App.git'
            }
       }

        stage('Sonar Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh 'npm install'
                    sh 'npm run build'
                    sh '''
                    npx sonar-scanner \
                        -Dsonar.projectKey=react-quiz-app \
                        -Dsonar.sources=. \
                        -Dsonar.host.url=http://sonarqube:9000 \
                        -Dsonar.login=$SONAR_TOKEN
                    '''
                }
            }
        }

        stage('Build') {
            steps {
                sh 'npm install'
                sh 'npm run build'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t react-quiz-app .'
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1/', 'docker-hub-credentials') {
                        sh 'docker tag react-quiz-app $DOCKER_HUB_USER/react-quiz-app:latest'
                        sh 'docker push $DOCKER_HUB_USER/react-quiz-app:latest'
                    }
                }
            }
        }

        stage('Deploy and Start Docker Container') {
            steps {
                sh '''
                docker stop react-quiz-app || true
                docker rm react-quiz-app || true
                docker run -d -p 3000:3000 --name react-quiz-app $DOCKER_HUB_USER/react-quiz-app:latest
                '''
            }
        }
    }
    post {
        success {
            echo 'Pipeline exécuté avec succès 🚀'
        }
        failure {
            echo 'Erreur dans le pipeline ! 🚨'
        }
    }
}
