output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = module.vpc.subnet_id
}

output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2.public_ip
}

output "iam_role_name" {
  description = "The IAM role name"
  value       = module.iam.role_name
}

output "s3_bucket_name" {
  description = "The name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "ecr_repo_url" {
  description = "The ECR repository URL"
  value       = module.ecr.repo_url
}

