pipeline {
    agent any
    environment {
        DOCKER_HUB_USER = 'manal403'
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
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=squ_a14cbbdcfc21d9c07a0b9e3334c4da34702ae11a
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
                    withDockerRegistry([url: 'https://index.docker.io/v1/', credentialsId: 'docker-hub-credentials']) {
                        sh 'docker tag react-quiz-app manal403/react-quiz-app:latest'
                        sh 'docker push manal403/react-quiz-app:latest'
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
