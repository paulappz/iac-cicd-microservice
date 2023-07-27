data "aws_ami" "anchore" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["anchore-*"]
  }
}
  
resource "aws_security_group" "anchore_sg" {
  name        = "anchore_sg"
  description = "Allow traffic on port 9000 and enable SSH from bastion host"
  // Allow traffic on port 8228 from Jenkins masters sg and enable SSH from bastion host
  vpc_id      = aws_vpc.management.id

  ingress {
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_host.id]
  }

  ingress {
    from_port       = "8228"
    to_port         = "8228"
    protocol        = "tcp"
    security_groups = [aws_security_group.jenkins_master_sg.id]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "anchore_sg"
    Author = var.author
  }
}

resource "aws_instance" "anchore" {
  ami                    = data.aws_ami.anchore.id
  instance_type          = var.anchore_instance_type
  key_name               = aws_key_pair.management.id
  vpc_security_group_ids = [aws_security_group.anchore_sg.id]
  subnet_id              = element(aws_subnet.private_subnets, 0).id
  iam_instance_profile = aws_iam_instance_profile.ecr_workers_access.name

  root_block_device {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = false
  }

  tags = {
    Name   = "anchore"
    Author = var.author
  }
}



// Anchore ELB Security group
resource "aws_security_group" "elb_anchore_sg" {
  name        = "elb_anchore_sg"
  description = "Allow http & https traffic"
  vpc_id      = aws_vpc.management.id

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "elb_anchore_sg"
    Author = var.author
  }
}

// Anchore ELB
resource "aws_elb" "anchore_elb" {
  subnets                   = [for subnet in aws_subnet.public_subnets : subnet.id]
  cross_zone_load_balancing = true
  security_groups           = [aws_security_group.elb_anchore_sg.id]
  instances                 = [aws_instance.anchore.id]

  listener {
    instance_port      = 8228
    instance_protocol  = "http"
    lb_port            = 443
    lb_protocol        = "https"
    ssl_certificate_id = var.ssl_arn
  }

  listener {
    instance_port     = 8228
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"

  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9000"
    interval            = 5
  }

  tags = {
    Name   = "anchore_elb"
    Author = var.author
  }
}
