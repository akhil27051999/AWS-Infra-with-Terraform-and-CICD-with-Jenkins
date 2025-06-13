# 🔍 Detailed Explanation of Each Variable

### 1. aws_region

```hcl
variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

```
- Purpose: Specifies the AWS region for resource deployment.
- Default: us-east-1.
- Used In: provider block and likely across all modules.

---

### 2. vpc_cidr

```hcl
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
```

- Purpose: Defines the CIDR block for the VPC.
- Default: Large enough range to include multiple subnets.

---

### 3. subnet_cidr

``` hcl
variable "subnet_cidr" {
  default = "10.0.1.0/24"
}
```

- Purpose: CIDR block for a public subnet inside the VPC.
- Used By: aws_subnet resource inside the VPC module.

---

### 4. availability_zone

```hcl
variable "availability_zone" {
  default = "us-east-1a"
}
```

- Purpose: Determines in which availability zone the subnet/EC2 will be deployed.
- Use Case: Needed for subnet and EC2 instance creation.

---

### 5. ami_id

```hcl
variable "ami_id" {
  description = "AMI ID for EC2 instance"
}
```

- Purpose: Specifies the Amazon Machine Image (AMI) ID for launching the EC2 instance.
- No default: Must be provided during terraform apply.

---

### 6. instance_type

```hcl
variable "instance_type" {
  default = "t2.micro"
}
```

- Purpose: Specifies EC2 instance type (CPU, RAM).
- Default: t2.micro (Free-tier eligible).

### 7. key_name

```hcl
variable "key_name" {
  description = "Key pair name for EC2 access"
}
```

- Purpose: SSH key to access EC2 instance.
- No default: Must be provided.

---

### 8. bucket_name

```hcl
variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
}
```

- Purpose: Refers to an existing S3 bucket used (possibly for state backend).
- Use Case: Terraform state management or Jenkins artifact storage.

---

### 9. repo_name

```hcl
variable "repo_name" {
  description = "Name of the ECR repository"
}
```

- Purpose: Name for your Elastic Container Registry repository.
- Use Case: For Jenkins pipelines to push/pull Docker images.

