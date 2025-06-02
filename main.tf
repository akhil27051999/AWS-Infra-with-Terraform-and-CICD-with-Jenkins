provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source            = "./modules/vpc"
  vpc_cidr          = var.vpc_cidr
  subnet_cidr       = var.subnet_cidr
  availability_zone = var.availability_zone
}

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

module "ec2" {
  source               = "./modules/ec2"
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = module.vpc.subnet_id      # from VPC outputs
  key_name             = var.key_name
  vpc_id               = module.vpc.vpc_id         # from VPC outputs
  iam_instance_profile = module.iam.iam_instance_profile  # from IAM outputs
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
}

module "ecr" {
  source    = "./modules/ecr"
  repo_name = var.repo_name   # make sure ecr module accepts this variable
}

