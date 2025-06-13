# EC2 Module Explanation

### 1. main.tf

This file contains the actual AWS resources and their configurations for your EC2 instance.

```hcl

resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  iam_instance_profile   = var.iam_instance_profile

  user_data = file("${path.module}/user_data.sh")

  tags = {
    Name = "jenkins-server"
  }
}

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Allow SSH and Jenkins access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

1. `aws_instance` "jenkins": Defines an EC2 instance resource with the label "jenkins".
2. `ami`: Amazon Machine Image ID, pulled from the variable ami_id (Ubuntu AMI by default).
3. `instance_type`: Instance size/type, from the variable instance_type (default is t2.micro).
4. `subnet_id`: The subnet where the EC2 instance will be launched, passed via variable.
5. `key_name`: SSH key pair name for logging into the instance.
6. `vpc_security_group_ids`: Attaches a security group to the instance; here it refers to a security group resource defined below.
7. `iam_instance_profile`: IAM profile attached for permissions, optional with default null.
8. `user_data`: Runs a shell script during instance initialization (user_data.sh file in the module directory).
9. `tags`: Tags the instance with name "jenkins-server".
10. Defines a security group named jenkins-sg allowing inbound and outbound traffic:

**Ingress rules:**

- Port 22 for SSH access (open to all IPs 0.0.0.0/0)
- Port 8080 for Jenkins web UI (open to all IPs)

**Egress rule:**

- Allows all outbound traffic on any port and protocol (protocol = -1 means all protocols).
- The security group is attached to the VPC specified by vpc_id variable.

---

### 2. outputs.tf

These outputs provide key information about the EC2 instance after deployment:

```hcl

output "instance_id" {
  value = aws_instance.jenkins.id
}

output "public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "public_dns" {
  value = aws_instance.jenkins.public_dns
}

```
1. `instance_id`: The unique ID of the EC2 instance.
2. `public_ip`: The public IPv4 address assigned to the instance.
3. `public_dns`: The public DNS name for accessing the instance.
4. These outputs are helpful for connecting to the instance or for referencing it in other modules.

---

### 3. variables.tf

Defines all the input variables required by this module along with their types and descriptions:

```hcl

variable "ami_id" {
  description = "AMI ID for the Jenkins server (Ubuntu)"
  type        = string
  default     = "ami-084568db4383264d4"  # Ubuntu AMI
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID to launch instance in"
  type        = string
}

variable "key_name" {
  description = "SSH Key pair name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where instance will be launched"
  type        = string
}

variable "iam_instance_profile" {
  description = "IAM instance profile attached to EC2"
  type        = string
  default     = null
}
```
1. `ami_id`: The AMI ID to use for the instance (default is Ubuntu).
2. `instance_type`: The size of the EC2 instance (t2.micro by default).
3. `subnet_id`: The subnet where the instance will be launched — mandatory, no default.
4. `key_name`: SSH keypair name to access the EC2 instance — mandatory.
5. `vpc_id`: VPC ID the instance belongs to — mandatory.
6. `iam_instance_profile`: Optional IAM profile to assign to the EC2 instance.
---

### Summary for EC2 Module

1. Purpose: Launch a Jenkins EC2 instance with security groups allowing SSH and Jenkins access.
2. Flexible inputs: You can customize AMI, instance type, subnet, keypair, VPC, and IAM role.
3. Outputs: Instance ID, public IP, and DNS for easy access after provisioning.
4. User data script: Runs your user_data.sh on startup for setup/installation.
