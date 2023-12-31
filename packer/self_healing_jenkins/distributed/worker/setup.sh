#!/bin/bash

# echo "Install Java JDK 8"
# yum remove -y java
# yum install -y java-1.8.0-openjdk

# echo "Install Docker engine"
# yum update -y
# yum install docker -y
# usermod -aG docker ec2-user
# systemctl enable docker

# echo "Install git"
# yum install -y git


echo "Install Java JDK 11"
sudo yum update -y
sleep 20
sudo amazon-linux-extras install epel
sleep 20
sudo amazon-linux-extras install java-openjdk11

sleep 20
java -version



echo "Install Docker engine"
sleep 20
sudo yum install docker -y

sleep 20
usermod -aG docker ec2-user
systemctl enable docker
sleep 20



echo "Install git"
yum install -y git

# sudo yum upgrade

echo "Install SonarScanner"
wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.2.0.1873-linux.zip -P /tmp
unzip /tmp/sonar-scanner-cli-4.2.0.1873-linux.zip
mv sonar-scanner-4.2.0.1873-linux sonar-scanner
ln -sf /home/ec2-user/sonar-scanner/bin/sonar-scanner /usr/bin/sonar-scanner