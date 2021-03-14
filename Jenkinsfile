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
                sh "cd terraform-app-env && sudo terraform init && sudo terraform apply -auto-approve" 
            }
        }
        stage('Push Image to ECR Repo') { 
            steps {
                sh "aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 820990632491.dkr.ecr.us-east-1.amazonaws.com/node-app && docker tag app:latest 820990632491.dkr.ecr.us-east-1.amazonaws.com/node-app && docker push 820990632491.dkr.ecr.us-east-1.amazonaws.com/node-app:latest"
            }
        }
        stage('Deploy to Dev') { 
            steps {
                 sh "dev=\$(aws ec2 describe-instances --filter 'Name=tag:Name,Values=Dev Server' 'Name=instance-state-name,Values=running' --query 'Reservations[*].Instances[*].PublicIpAddress' --output=text --region=us-east-1) && ssh ubuntu@\$dev -i key.pem  bash -x /home/ubuntu/app-deploy.sh"
            }
        }
        stage('Deploy to QA') { 
            steps {
                 sh "qa=\$(aws ec2 describe-instances --filter 'Name=tag:Name,Values=QA Server' 'Name=instance-state-name,Values=running' --query 'Reservations[*].Instances[*].PublicIpAddress' --output=text --region=us-east-1) && ssh ubuntu@\$qa -i key.pem  bash -x /home/ubuntu/app-deploy.sh"
            }
        }
        stage('Deploy to Prod') { 
            steps {
                 sh "prod=\$(aws ec2 describe-instances --filter 'Name=tag:Name,Values=Prod Server' 'Name=instance-state-name,Values=running' --query 'Reservations[*].Instances[*].PublicIpAddress' --output=text --region=us-east-1) && ssh ubuntu@\$prod -i key.pem  bash -x /home/ubuntu/app-deploy.sh"
            }
        }
    }
}
