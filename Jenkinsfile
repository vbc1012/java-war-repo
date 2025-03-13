pipeline {
    agent { label 'MavenAgents' }

    environment {
        DOCKER_HOST = "tcp://34.239.126.72:2375"  // Remote Docker Host
        IMAGE_NAME = "myapp3"
        IMAGE_TAG = "v2"
        DOCKER_USER = "your-dockerhub-username"
        DOCKER_PASS = "your-dockerhub-password"
        AWS_REGION = 'us-east-1'
        AWS_ACCOUNT_ID = '490004634805'
        ECR_REPO = 'jenkinsrepo'
        ECR_URI = "${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${ECR_REPO}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/vbc1012/java-war-repo.git'
            }
        }

        stage('Build with Maven') {
            steps {
                sh 'mvn clean package'
            }
        }
        
        stage('Run Unit Tests') {
            steps {
                sh 'mvn test'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Login to ECR') {
            steps {
                script {
                    sh "aws ecr get-login-password --region ${AWS_REGION} | docker login --username AWS --password-stdin ${ECR_URI}"
                }
            }
        }

        stage('Tag and Push Image') {
            steps {
                script {
                    sh """
                    docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${ECR_URI}:${IMAGE_TAG}
                    docker push ${ECR_URI}:${IMAGE_TAG}
                    """
                }
            }
        }
    }
}
