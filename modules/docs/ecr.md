# ECR Module Explanation

## 1. main.tf
This file defines your Amazon ECR (Elastic Container Registry) repository resource.

```hcl

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
```

1. aws_ecr_repository "jenkins_repo": Creates an ECR repository named "jenkins-ecr-repo".
2. name: The repository name is set explicitly as "jenkins-ecr-repo" (could be parameterized via variable, but here it’s hardcoded).
3. image_tag_mutability: Set to "MUTABLE", which means image tags in the repository can be overwritten/reused.
4. lifecycle { prevent_destroy = true }: This protects the repository from accidental deletion by Terraform. Even if you run terraform destroy, this resource won’t be removed.
5. tags: Tags the repository with the name "Jenkins ECR Repo" for easier identification.

---
## 2. variables.tf

```hcl
variable "repo_name" {}
```
1. Defines a variable repo_name, but it is currently not used in the main.tf. This means either the repo name is hardcoded or you might plan to parameterize it later. If you want to use it, you could replace name = "jenkins-ecr-repo" with name = var.repo_name in main.tf.

---
## 3. outputs.tf
```hcl

output "repo_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.jenkins_repo.repository_url
}
```

1. Outputs the URL of the created ECR repository.
2. This is useful for your CI/CD pipelines or Docker commands to push/pull images to/from this repository.

---
### Summary for ECR Module
- Purpose: To create and manage an Amazon ECR repository for storing your Docker container images.

**Key features:**
1. The repo is named jenkins-ecr-repo.
2. Allows mutable image tags (you can overwrite tags).
3. Prevents accidental destruction of the repo.
4. Output: Provides the repository URL to use for pushing images.
5. Variables: Currently, the repo name is hardcoded; the variable is defined but not utilized.

