resource "aws_iam_policy" "policy" {
  name        = var.policy_name
  path        = var.policy_path
  description = var.policy_desc


  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
       {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
      {
        Action = [
          "s3:ListBucket",
           "s3:GetObject",

        ]
        Effect   = "Allow"
        Resource = var.s3_arn
      },
    ]
  })
}