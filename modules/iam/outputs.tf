output "role_name" {
  value = aws_iam_role.jenkins_role.name
}

output "iam_instance_profile" {
  value = aws_iam_instance_profile.jenkins_profile.name
}

