output "repo_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.jenkins_repo.repository_url
}

