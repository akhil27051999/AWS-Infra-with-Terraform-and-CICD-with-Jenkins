# 🔍 Detailed Explanation of outputs.tf file
### 1. vpc_id

```hcl
description = "The ID of the VPC"
value       = module.vpc.vpc_id
```

- Description: Outputs the unique identifier of the VPC created.
- Source: Comes from the vpc module’s internal output "vpc_id".

---

### 2. subnet_id

```hcl
description = "The ID of the subnet"
value       = module.vpc.subnet_id
```

- Description: Outputs the ID of the public subnet.
- Use Case: Often used to deploy EC2 or attach route tables.

---

### 3. ec2_instance_id

```hcl
description = "The ID of the EC2 instance"
value       = module.ec2.instance_id
```

- Description: Outputs the unique EC2 instance ID.
- Source: From ec2 module.

---

### 4. ec2_public_ip

```hcl
description = "The public IP address of the EC2 instance"
value       = module.ec2.public_ip
```

- Description: Public IP used to SSH or open Jenkins in a browser.
- Use Case: Critical for accessing Jenkins UI or remote debugging.

---

### 5. iam_instance_profile

```hcl
description = "The IAM instance profile name"
value       = module.iam.iam_instance_profile
```

- Description: Name of the IAM instance profile attached to the EC2.
- Use Case: Required to associate the role with EC2 securely.

---

### 6. iam_role_name

```hcl
description = "The IAM role name"
value       = module.iam.role_name
```

- Description: Displays the name of the IAM role created.
- Use Case: For verification or attaching permissions/policies.

---

### 7. s3_bucket_name

```hcl
description = "The name of the S3 bucket"
value       = module.s3.bucket_name
```

- Description: Outputs the name of the referenced S3 bucket.
- Use Case: Can be used for Terraform backend or Jenkins artifact storage.

---

### 8. ecr_repo_url

```hcl
description = "The ECR repository URL"
value       = module.ecr.repo_url
```

- Description: Full URL of the Docker image repository.
- Use Case: Use this in your Jenkins pipeline to push/pull Docker images.

