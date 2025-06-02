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

