#!/bin/bash

echo "Install Java JDK 8"
yum remove -y java

amazon-linux-extras install epel

amazon-linux-extras install java-openjdk11

echo "Install Docker engine"
yum update -y
yum install docker -y
usermod -aG docker ec2-user
service docker start

echo "Install Docker Compose"
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
#docker-compose --version

echo "Install Anchore"

curl https://engine.anchore.io/docs/quickstart/docker-compose.yaml > docker-compose.yaml
# docker-compose up -d


yum install -y epel-release python-pip 
#pip install anchorecli
python3 -m pip install anchorecli


mkdir ~/aevolume
mkdir ~/aevolume/config
mkdir ~/aevolume/db
#cd ~/aevolume

# https://medium.com/@maheshd7878/anchore-for-checking-docker-image-vulnerabilities-3d644d5c6994
curl https://raw.githubusercontent.com/mahesh-wabale/anchore/master/config/config.yaml >  ~/aevolume/config/config.yaml
curl https://raw.githubusercontent.com/mahesh-wabale/anchore/master/docker-compose.yaml > ~/aevolume/docker-compose.yaml

# Add ECR TO ANCORE EC2 ROLE TO ANCHORE


cd ~/aevolume

#docker-compose pull

#docker-compose up -d

#docker-compose ps

anchore-cli --u admin --p foobar registry add 570942461061.dkr.ecr.eu-west-2.amazonaws.com awsauto awsauto --registry-type=awsecr --skip-validate
