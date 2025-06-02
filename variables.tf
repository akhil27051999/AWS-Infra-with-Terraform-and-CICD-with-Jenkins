variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "Key pair name for EC2 access"
}

variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
}

variable "repo_name" {
  description = "Name of the ECR repository"
}

