resource "aws_iam_policy" "full_eks_jenkins_master_policy" {
  name        = "full_eks_jenkins_master_policy"
  description = "Jenkins master policy access to full eks access"
  path        = "/"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "eks:*"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "iam:PassedToService": "eks.amazonaws.com"
                }
            }
        }
    ]
}
EOF
}


resource "aws_iam_role" "full_eks_jenkins_master_role" {
  name        = "full_eks_jenkins_master_role"
  description = "Jenkins master full role access to eks"

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

resource "aws_iam_role_policy_attachment" "full_eks_jenkins_master_access" {
  role       = aws_iam_role.full_eks_jenkins_master_role.name
  policy_arn = aws_iam_policy.full_eks_jenkins_master_policy.arn
}