locals {
 
  repositories = {
    
    "paulappz/quote-service" = {
      image_tag_mutability  = "MUTABLE"
      scan_on_push          = true
      expiration_after_days = 7
      environment           = "develop"
      tags = {
        Project     = "quote"
        Owner       = "Paul Oluyege"
        Purpose     = "CICD POC"
        Description = "quote-service API"
      }
    }
    
     "paulappz/quote-api-gateway" = {
      image_tag_mutability  = "MUTABLE"
      scan_on_push          = true
      expiration_after_days = 7
      environment           = "develop"
      tags = {
        Project     = "quote"
        Owner       = "Paul Oluyege"
        Purpose     = "CICD POC"
        Description = "quote-api gatwway"
      }
    }
    
       "paulappz/quote-web" = {
      image_tag_mutability  = "MUTABLE"
      scan_on_push          = true
      expiration_after_days = 7
      environment           = "develop"
      tags = {
        Project     = "quote"
        Owner       = "Paul Oluyege"
        Purpose     = "CICD POC"
        Description = "quote web"
      }
    }
    
  }
}

resource "aws_ecr_repository" "ecr_repository" {
  for_each = local.repositories

  name                  = each.key

  image_tag_mutability  = each.value.image_tag_mutability

     image_scanning_configuration {
    scan_on_push = each.value.scan_on_push
  }
   tags = merge(
    each.value.tags,
    {
      ManagedBy = "Terraform"
      Environment = each.value.environment
    }
  )

}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {

for_each = local.repositories

  repository = aws_ecr_repository.ecr_repository[each.key].name
  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than ${each.value.expiration_after_days} days",
            "selection": {
                "tagStatus": "any",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": ${each.value.expiration_after_days}
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}