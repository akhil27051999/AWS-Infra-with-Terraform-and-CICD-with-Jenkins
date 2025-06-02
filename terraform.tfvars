aws_region        = "us-east-1"
ami_id            = "ami-0c02fb55956c7d316"   # Example Ubuntu AMI ID, replace if needed
key_name          = "your-key-pair-name"     # Replace with your EC2 key pair
bucket_name       = "my-terraform-state-bucket"
repo_name         = "my-app-repo"
instance_type     = "t2.micro"
vpc_cidr          = "10.0.0.0/16"
subnet_cidr       = "10.0.1.0/24"
availability_zone = "us-east-1a"

