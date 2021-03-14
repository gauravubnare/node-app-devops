#!/bin/bash
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
ECR_ARN=820990632491.dkr.ecr.us-east-1.amazonaws.com/node-app
REGION=us-east-1
sudo apt update -y 
sudo apt install awscli docker docker.io -y
sudo systemctl start docker 
sudo systemctl enable docker 
sudo usermod ubuntu -g docker
echo "
sudo docker system prune -af

sudo aws ecr get-login-password --region $REGION | sudo docker login --username AWS --password-stdin $ECR_ARN

sudo docker pull $ECR_ARN

sudo docker rm -f node-app-container

### Deploy Conatiners ###

sudo docker run -d -p 80:80 --restart=always --name "node-app-container"  $ECR_ARN

" > /home/ubuntu/app-deploy.sh
