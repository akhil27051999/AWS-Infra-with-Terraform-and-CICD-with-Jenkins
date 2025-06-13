# 🔍 Detailed Explanation of Main.TF file

- This is the orchestrator file that:
- Sets the AWS provider region.
- Calls different Terraform modules (VPC, IAM, EC2, S3, ECR).
- Passes necessary input variables to those modules.
- Connects the outputs of one module as inputs to another (e.g., VPC subnet ID to EC2).

## 🔍 Line-by-Line Breakdown

### 1. AWS Provider Block

```hcl
provider "aws" {
  region = var.aws_region
}
```

1. Configures the AWS provider with a region.
2. var.aws_region is a variable, likely defined in variables.tf or passed via CLI.

---

### 2. VPC Module Call
```hcl
module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
}
```

1. Uses the VPC module defined in ./modules/vpc.
2. Passes three variables to create:
3. A VPC with CIDR block (vpc_cidr)
4. A public subnet (subnet_cidr)
5. In a given availability zone (availability_zone)

**✅ Outputs Used Later:**

1. module.vpc.vpc_id
2. module.vpc.subnet_id

---

### 3. IAM Module Call

```hcl

module "iam" {
  source            = "./modules/iam"
  role_name         = "jenkins-role"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
POLICY
}
```

**Calls the IAM module to:**

1. Create an IAM role for EC2 (named jenkins-role)
2. Provide an assume role policy in JSON format (hardcoded here using heredoc syntax <<POLICY ... POLICY)
3. This role allows EC2 to assume it via sts:AssumeRole

**✅ Output Used Later:**

1. module.iam.iam_instance_profile

---

### 4. EC2 Module Call
```hcl
module "ec2" {
  source               = "./modules/ec2"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = module.vpc.subnet_id
  key_name             = var.key_name
  vpc_id               = module.vpc.vpc_id
  iam_instance_profile = module.iam.iam_instance_profile
}
```

**Provisions an EC2 instance with:**
1. `ami_id`: AMI to use (e.g., Ubuntu, Amazon Linux)
2. `instance_type`: e.g., t2.micro
3. `subnet_id`: From vpc module output
4. `key_name`: SSH key for access
5. `vpc_id`: For security group/routing
6. `iam_instance_profile`: From iam module output for attaching the IAM role

---

### 5. S3 Module Call
```hcl
module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

```
**Uses an existing S3 bucket (akhil27051999) to:**
1. Optionally enable versioning
2. Manage Terraform state or store Jenkins artifacts/logs
   
---

### 6. ECR Module Call
```hcl
module "ecr" {
  source    = "./modules/ecr"
  repo_name = var.repo_name
}

```

**Creates an ECR (Elastic Container Registry) repo to:**
1. Store Docker images for Jenkins or other microservices
2. Uses a dynamic name passed via var.repo_name (e.g., "jenkins-ecr-repo")



## ✅ Overall Flow Summary

- `Step 1`: Configure AWS region via provider
- `Step 2`: Create networking (VPC, Subnet, IGW, Route Table)
- `Step 3`: Create IAM role for EC2
- `Step 4`: Launch EC2 in the subnet, with IAM role
- `Step 5`: Reference an existing S3 bucket (optional: enable versioning)
- `Step 6`: Create an ECR repository for Jenkins or app images


## 🧩 Dependencies (Module Chaining)

- vpc → ec2: Subnet ID, VPC ID
- iam → ec2: IAM profile

This chaining ensures proper order of resource creation.

