resource "aws_ecr_repository" "jenkins_repo" {
  name                 = "jenkins-ecr-repo"
  image_tag_mutability = "MUTABLE"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "Jenkins ECR Repo"
  }
}

