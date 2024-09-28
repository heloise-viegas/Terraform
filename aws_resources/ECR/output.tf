output "ecr_name" {
    value = aws_ecr_repository.ecr.name
}

/*
output "ecr_lifecycle_policy_arn" {
   value = aws_ecr_lifecycle_policy.ecr_lifecycle_policy.arn
}
*/