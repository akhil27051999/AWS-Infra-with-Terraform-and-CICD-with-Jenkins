# 🚀 Automated AWS Infrastructure and CI/CD Pipeline with Terraform & Jenkins

## 👨‍💻 Project Goal

Provision and automate AWS infrastructure using **Terraform modules**, and deploy a **CI/CD pipeline** using **Jenkins running in Docker** inside an EC2 instance. 
This project follows Infrastructure as Code (IaC) principles to enable reusable, version-controlled, and fully automated cloud environments.

---

## 📦 Section 1: Tools and Technologies

| Tool        | Purpose                              |
|-------------|--------------------------------------|
| Terraform   | Infrastructure as Code (IaC)         |
| AWS         | Cloud Provider                       |
| Jenkins     | CI/CD Automation                     |
| Docker      | Containerization of Jenkins          |
| GitHub      | Version Control & Pipeline Trigger   |

---

## 🧱 Section 2: Prerequisites & Setup

### ✅ 2.1 Install Terraform
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
terraform -v
```

### ✅ 2.2 Install AWS CLI
```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configure
```

**Provide:**
1. Access Key ID
2. Secret Access Key
3. AWS Region (e.g., us-east-1)
4. Output Format (e.g., json)

### ✅ 2.3 Setup AWS IAM User

`AWS Console → IAM → Users → Create User`
- Enable Programmatic Access
- Attach policies:

1. AmazonEC2FullAccess
2. AmazonS3FullAccess
3. AmazonECRFullAccess
   
- Save Access & Secret Keys

---
## 🏗️ Section 3: Project Structure
```css
project-root/
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ec2/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── iam/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── s3/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── ecr/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
```

---
## 🔧 Section 4: Terraform Modules Overview

 ### 4.1 VPC Module
- Creates VPC, Subnet, Internet Gateway, Route Table
- Uses variables like CIDR block and Availability Zone
- Outputs: VPC ID, Subnet ID

### 4.2 EC2 Module
- Provisions EC2 in public subnet
- Installs Jenkins inside Docker using user_data
- Opens ports 22 (SSH), 8080 (Jenkins)
- Outputs: EC2 Instance ID, Public IP

### 4.3 IAM Module
- Creates IAM Role for EC2 to access AWS services
- Attaches AmazonEC2FullAccess policy
- Output: IAM Role name

### 4.4 S3 Module
- Creates version-enabled S3 bucket (e.g., for Terraform backend or artifacts)
- Output: S3 Bucket name

### 4.5 ECR Module
- Creates ECR repository for Docker image storage
- Output: ECR Repository URI

---
## 🛠️ Section 5: Terraform Commands
```bash
terraform init       # Initialize modules and backend
terraform plan       # Review what changes will be made
terraform apply      # Apply infrastructure changes
terraform destroy    # Destroy all created resources
```

---
## 🚀 Section 6: Jenkins Installation via user_data

**When the EC2 instance launches, the following script runs automatically:**
```bash
#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo usermod -aG docker ubuntu
docker run -d -p 8080:8080 -p 50000:50000 --name jenkins \
  -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
Jenkins will be accessible at:
http://<EC2-Public-IP>:8080
```

---
## 🔄 Section 7: Jenkins CI/CD Pipeline

### ✅ Sample Jenkinsfile
```groovy
pipeline {
  agent any

  stages {
    stage('Clone Repo') {
      steps {
        git 'https://github.com/your/repo.git'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          docker.build('my-app')
        }
      }
    }

    stage('Push to ECR') {
      steps {
        sh 'aws ecr get-login-password | docker login --username AWS --password-stdin <aws_account_id>.dkr.ecr.<region>.amazonaws.com'
        sh 'docker tag my-app:latest <aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-app'
        sh 'docker push <aws_account_id>.dkr.ecr.<region>.amazonaws.com/my-app'
      }
    }
  }
}
```

---

## 📬 Section 8: Final Output
### ✅ AWS Resources Created:

- VPC with public subnet
- EC2 instance with Jenkins in Docker
- IAM Role for EC2
- S3 bucket for storing Terraform state
- ECR repository for Docker images

### ✅ CI/CD Outcome:

- Jenkins running at http://<EC2-Public-IP>:8080
- CI/CD pipeline triggers on code push to GitHub
- Docker images built and pushed to ECR
![image](https://github.com/user-attachments/assets/73cf8f1d-ea68-497b-bd00-e9ae79fb20f9)
