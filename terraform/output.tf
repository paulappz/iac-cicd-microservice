output "bastion" {
  value = aws_instance.bastion.public_ip
}

output "anchore_ip" {
  value = aws_instance.anchore.private_ip
}

output "jenkins_master_ip" {
  value = aws_instance.jenkins_master.private_ip
}

output "sonarqube_ip" {
  value = aws_instance.sonarqube.private_ip
}

output "bastion_key" {
  value = aws_key_pair.management.id
}

output "jenkins-master-elb" {
  value = aws_elb.jenkins_elb.dns_name
}


output "sonarqube-elb" {
  value = aws_elb.sonarqube_elb.dns_name
}

output "anchore-elb" {
  value = aws_elb.anchore_elb.dns_name
}


output "jenkins-dns" {
  value = "https://${aws_route53_record.jenkins_master.name}"
}

output "sonarqube-dns" {
  value = "https://${aws_route53_record.sonarqube.name}"
}

output "anchore-dns" {
  value = "https://${aws_route53_record.anchore.name}"
}