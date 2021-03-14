pipeline {
    agent any 
    stages {
        stage('Build') { 
            steps {
                sh "cd docker-app && docker build -t app:latest ." 
            }
        }
        stage('Deploy or Update the Infra') { 
            steps {
                sh "cd terraform-app-env && terraform init && terraform apply -auto-approve" 
            }
        }
        stage('Push Image to ECR Repo') { 
            steps {
                sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 820990632491.dkr.ecr.us-east-1.amazonaws.com/node-app && docker tag app:latest 820990632491.dkr.ecr.us-east-1.amazonaws.com/node-app && docker push 820990632491.dkr.ecr.us-east-1.amazonaws.com/node-app:latest"
            }
        }
        stage('Deploy to Dev') { 
            steps {
                 sh "ssh ubuntu@54.147.236.110 bash /home/ubuntu/app-deploy.sh"
            }
        }
        stage('Deploy to QA') { 
            steps {
                 sh "ssh ubuntu@54.209.227.131 bash /home/ubuntu/app-deploy.sh"
            }
        }
        stage('Deploy to Prod') { 
            steps {
                 sh "ssh ubuntu@3.92.198.18 bash /home/ubuntu/app-deploy.sh"
            }
        }
    }
}