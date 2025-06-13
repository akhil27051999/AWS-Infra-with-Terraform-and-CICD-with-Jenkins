# AWS Infrastructure using Terraform and CI/CD Pipeline with Jenkins

## 👨‍💻 Project Goal

Provision and automate AWS infrastructure using **Terraform modules**, and deploy a **CI/CD pipeline** using **Jenkins running in Docker** inside an EC2 instance. 
This project follows Infrastructure as Code (IaC) principles to enable reusable, version-controlled, and fully automated cloud environments.

![0226-TerraformJenkinsCICD-Waldek_Social](https://github.com/user-attachments/assets/7d11c2c4-3fd5-4358-969e-f69a92bce3d9)


---

## 🛠 Tech Stack

| Tool        | Purpose                              |
|-------------|--------------------------------------|
| Terraform   | Infrastructure as Code (IaC)         |
| AWS         | Cloud Provider                       |
| Jenkins     | CI/CD Automation                     |
| Docker      | Containerization of Jenkins          |
| GitHub      | Version Control & Pipeline Trigger   |

---
## 📁 Project Structure
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
├── app/
│   ├── Dockerfile
│   ├── app.py
│   ├── requirements.txt
│   └── Jenkinsfile

```

## 🧱 Project Section-wise Overview

## Section 1: Prerequisites & Setup

### ✅ 1.1 Install Terraform
```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
terraform -v
```

### ✅ 1.2 Install AWS CLI
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

### ✅ 1.3 Setup AWS IAM User

`AWS Console → IAM → Users → Create User`
- Enable Programmatic Access
- Attach policies:

1. `AmazonEC2FullAccess`
2. `AmazonS3FullAccess`
3. `AmazonECRFullAccess`
   
- Save Access & Secret Keys
  
---
## Section 2: Terraform Modules Overview

 ### 2.1 VPC Module
- Creates VPC, Subnet, Internet Gateway, Route Table
- Uses variables like CIDR block and Availability Zone
- Outputs: VPC ID, Subnet ID

### 2.2 EC2 Module
- Provisions EC2 in public subnet
- Installs Jenkins inside Docker using user_data
- Opens ports 22 (SSH), 8080 (Jenkins)
- Outputs: EC2 Instance ID, Public IP

### 2.3 IAM Module
- Creates IAM Role for EC2 to access AWS services
- Attaches AmazonEC2FullAccess policy
- Output: IAM Role name

### 2.4 S3 Module
- Creates version-enabled S3 bucket (e.g., for Terraform backend or artifacts)
- Output: S3 Bucket name

### 2.5 ECR Module
- Creates ECR repository for Docker image storage
- Output: ECR Repository URI

---
## Section 3: Terraform Commands
```bash
terraform init       # Initialize modules and backend
terraform plan       # Review what changes will be made
terraform apply      # Apply infrastructure changes
terraform destroy    # Destroy all created resources
```

### Terraform Init Output
![Screenshot 2025-06-02 170205](https://github.com/user-attachments/assets/abb652b8-7456-4919-bec1-6bb1026e09f4)

### Terraform Plan Outputs
![Screenshot 2025-06-02 174457](https://github.com/user-attachments/assets/06828399-cbc5-435a-a66a-74d16fe42249)
![Screenshot 2025-06-02 174531](https://github.com/user-attachments/assets/9e19d359-f055-4b95-8051-ad3af2faf209)
![Screenshot 2025-06-02 174552](https://github.com/user-attachments/assets/741c8bca-2801-41ae-ba97-9ca5d0b4ebc1)
![Screenshot 2025-06-02 174612](https://github.com/user-attachments/assets/eb2681f1-ca3c-4078-9489-1092230a18a5)
![Screenshot 2025-06-02 174726](https://github.com/user-attachments/assets/e5e1ff3e-89ab-4d2a-b885-8eefa47085d2)

### Terraform Apply Outputs
![Screenshot 2025-06-02 180933](https://github.com/user-attachments/assets/1ec98ef1-87d1-45a3-9e8e-46ec8a34602e)

---
## Section 4: Jenkins Installation via user_data

**When the EC2 instance launches, the following script runs automatically:**
```bash
#!/bin/bash
sudo apt update -y
sudo apt install docker.io -y
sudo systemctl start docker
sudo usermod -aG docker ubuntu

docker run -d -p 8080:8080 -p 50000:50000 --name jenkins \
  -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts

# Jenkins will be accessible at:
http://<EC2-Public-IP>:8080
```

---
## Section 5: Jenkins CI/CD Pipeline

### Sample Jenkinsfile
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

## Jenkins Outputs

### Jenkins Pipeline Output
![Screenshot 2025-06-02 225050](https://github.com/user-attachments/assets/efd214fd-ec79-4f10-8f87-133abcecaaa5)
---

## Section 6: Final Output
### AWS Resources Created:

- VPC with public subnet
- EC2 instance with Jenkins in Docker
- IAM Role for EC2
- S3 bucket for storing Terraform state
- ECR repository for Docker images

### CI/CD Outcome:

- Jenkins running at http://<EC2-Public-IP>:8080
- CI/CD pipeline triggers on code push to GitHub
- Docker images built and pushed to ECR

---
# 📊 Project Outputs

## AWS Resources Outputs

### VPC Output
![Screenshot 2025-06-02 181748](https://github.com/user-attachments/assets/73263db7-295d-4165-9018-a68fa80a593d)

### EC2 Instance Output
![Screenshot 2025-06-02 181850](https://github.com/user-attachments/assets/65cc495a-89f3-42fc-b918-0e047d31a1a1)

### S3 Bucket Output
![Screenshot 2025-06-02 181937](https://github.com/user-attachments/assets/7ee66fe6-47f1-4eee-b7ba-50c22cc24c64)

### IAM Role Output
![Screenshot 2025-06-02 182038](https://github.com/user-attachments/assets/dd65f241-c506-4722-a108-1dcd8956d1ce)

### Amazon ECR Output
![Screenshot 2025-06-02 182249](https://github.com/user-attachments/assets/d7b44aba-4951-4be2-9bef-015ddbf1b07f)



