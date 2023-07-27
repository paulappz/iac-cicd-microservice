resource "aws_iam_policy" "ecr_jenkins_workers_policy" {
  name        = "ecr_jenkins_workers_policy"
  description = "Jenkins workers policy access to ecr"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:*",
                "cloudtrail:LookupEvents"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "iam:CreateServiceLinkedRole"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:AWSServiceName": [
                        "replication.ecr.amazonaws.com"
                    ]
                }
            }
        }
    ]
}
EOF
}


resource "aws_iam_role" "ecr_jenkins_workers_role" {
  name        = "ecr_jenkins_workers_role"
  description = "Jenkins workers role access to ecr"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_jenkins_access" {
  role       = aws_iam_role.ecr_jenkins_workers_role.name
  policy_arn = aws_iam_policy.ecr_jenkins_workers_policy.arn
}