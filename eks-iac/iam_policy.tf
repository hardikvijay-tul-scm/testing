resource "aws_iam_policy" "centraleks_policy" {
  name        = "centraleks_policy"
  policy = jsonencode({    
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "Statement1",
            "Effect": "Allow",
            "Action": [
                "lambda:*",
                "elasticfilesystem:*",
                "dlm:*",
                "sagemaker:*",
                "secretsmanager:*",
                "glue:*",
                "es:*",
                "cloudformation:*",
                "cloudwatch:*",
                "logs:*",
                "eks:*",
                "ecr:*",
                "ssm:*",
                "ec2:*",
                "autoscaling:*",
                "kms:*",
                "rds:*",
                "ec2-instance-connect:*",
                "ecr:*",
                "rds:*",
                "iam:*",
                "lambda:*",
                "redshift-data:*",
                "dynamodb:*",
                "route53:*",
                "s3:*",
                "sns:*",
                "kafka:*",
                "acm-pca:*",
                "states:*",
                "events:*",
                "ses:*",
                "sts:AssumeRole",
                "redshift:*",
                "tag:getResources",
                "tag:getTagKeys",
                "tag:getTagValues",
                "tag:TagResources",
                "tag:UntagResources",
                "resource-groups:*"
            ],
            "Resource": "*"
        }
    ]
})

  tags = {
    Owner = "centraleks"
  }
}
