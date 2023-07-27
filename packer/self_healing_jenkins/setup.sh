
#!/bin/bash
sleep 10
sudo yum update -y
sleep 10
sudo amazon-linux-extras install epel
sleep 10
sudo amazon-linux-extras install java-openjdk11
sleep 10
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sleep 5
java -version
sudo yum upgrade
sleep 10
sudo yum install -y jenkins
sleep 10
sudo systemctl daemon-reload
sleep 10
sudo systemctl start jenkins 
sleep 10
sudo systemctl status jenkins


