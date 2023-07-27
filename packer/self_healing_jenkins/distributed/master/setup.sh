#!/bin/bash
sleep 30
sudo yum update -y
sleep 20
sudo amazon-linux-extras install epel
sleep 20
sudo amazon-linux-extras install java-openjdk11
sleep 20
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo

sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

#sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sleep 20
java -version
sudo yum upgrade
sleep 20
sudo yum install -y jenkins
sleep 20
sudo systemctl daemon-reload
sleep 20



echo "Install git"
sleep 20
yum install -y git

sleep 20
echo "Setup SSH key"
mkdir /var/lib/jenkins/.ssh
touch /var/lib/jenkins/.ssh/known_hosts
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh
mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa
chmod 600 /var/lib/jenkins/.ssh/id_rsa
chown -R jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa

echo "Configure Jenkins"
mkdir -p /var/lib/jenkins/init.groovy.d
mv /tmp/scripts/*.groovy /var/lib/jenkins/init.groovy.d/
chown -R jenkins:jenkins /var/lib/jenkins/init.groovy.d
mv /tmp/config/jenkins /etc/sysconfig/jenkins
chmod +x /tmp/config/install-plugins.sh
bash /tmp/config/install-plugins.sh

sleep 20
sudo systemctl start jenkins 
sleep 20
sudo systemctl status jenkins
