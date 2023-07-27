resource "aws_route53_record" "jenkins_master" {
  zone_id = var.hosted_zone_id
  name    = "jenkins.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.jenkins_elb.dns_name
    zone_id                = aws_elb.jenkins_elb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "sonarqube" {
  zone_id = var.hosted_zone_id
  name    = "sonarqube.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.sonarqube_elb.dns_name
    zone_id                = aws_elb.sonarqube_elb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "anchore" {
  zone_id = var.hosted_zone_id
  name    = "anchore.${var.domain_name}"
  type    = "A"

  alias {
    name                   = aws_elb.anchore_elb.dns_name
    zone_id                = aws_elb.anchore_elb.zone_id
    evaluate_target_health = true
  }
}