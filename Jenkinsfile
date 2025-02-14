pipeline {
    agent { label 'maven_agent_1' }
    
    stages {
        stage('Clone Repository') {
            steps {
                sh 'git clone https://github.com/vbc1012/java-war-repo.git'
            }
        }

        stage('Build') {
            steps {
                sh '''
                    cd java-war-repo
                    mvn clean install
                '''
            }
        }
    }

    post {
        success {
            echo 'Build completed successfully!'
        }
        failure {
            echo 'Build failed. Check the logs.'
        }
    }
}
