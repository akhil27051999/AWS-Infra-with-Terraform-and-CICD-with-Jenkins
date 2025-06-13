# IAM Module Explanation

### 1. main.tf

This file creates the IAM Role and Instance Profile used by your Jenkins EC2 instance.

```hcl

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "Jenkins EC2 IAM Role"
  }
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_role.name
}
```

1. `aws_iam_role "jenkins_role"`: Creates an IAM role named "jenkins-role".
2. The assume_role_policy defines who can assume this role.
3. The policy allows the EC2 service (`ec2.amazonaws.com`) to assume this role, which means this role can be attached to EC2 instances.
4. `Tags`: it with "Jenkins EC2 IAM Role" for identification.
5. `aws_iam_instance_profile "jenkins_profile"`: Creates an instance profile named "jenkins-instance-profile".
6. This profile links the above IAM role to be assigned to EC2 instances.
7. EC2 instances require an instance profile to attach IAM roles.

---

### 2. outputs.tf
```hcl
output "role_name" {
  value = aws_iam_role.jenkins_role.name
}

output "iam_instance_profile" {
  value = aws_iam_instance_profile.jenkins_profile.name
}
```
1. `role_name`: Outputs the name of the IAM role (jenkins-role).
2. `iam_instance_profile`: Outputs the name of the instance profile (jenkins-instance-profile).
3. These outputs are helpful for referencing the IAM resources in other modules (for example, attaching the instance profile to an EC2 instance).

---

### 3. variables.tf

```hcl
variable "role_name" {}
variable "assume_role_policy" {}
```

1. `Variables` are defined for `role_name` and `assume_role_policy`, but they are not currently used in your main.tf (which has hardcoded values).
2. You could parameterize the role name and assume role policy in the future by referencing these variables instead of hardcoding.

---

### Summary for IAM Module
- Purpose: To create an IAM Role and Instance Profile for EC2 instances to securely access AWS resources.
   
**Key components:**
1. IAM Role with trust policy allowing EC2 service to assume the role.
2. Instance Profile to attach the IAM role to EC2.
3. Outputs: Expose the role name and instance profile name for integration.
4. Variables: Defined but unused; you may want to make your module more flexible by using them.

