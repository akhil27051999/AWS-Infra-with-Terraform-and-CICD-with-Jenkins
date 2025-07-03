# ☁️ How Terraform Provisions AWS Resources

## 🚀 Overview: How Terraform Talks to AWS

| Step | What Happens |
|------|--------------|
| 1️⃣ | You write Terraform configuration files (`.tf`) to define AWS resources |
| 2️⃣ | You provide AWS credentials so Terraform can authenticate to AWS |
| 3️⃣ | Terraform connects to AWS APIs using those credentials |
| 4️⃣ | Terraform creates, updates, or deletes resources as defined in your config |
| 5️⃣ | Terraform stores everything in a state file (`terraform.tfstate`) |


## 📦 Example Terraform Code

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my_vm" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

This configuration tells Terraform to:
- Use the AWS provider
- Launch an EC2 instance with the given AMI and type


## 🔐 AWS Authentication Methods

Terraform must authenticate to AWS to make API calls. You can provide credentials using:

| Method          | How                                                                 |
|-----------------|----------------------------------------------------------------------|
| AWS CLI         | `aws configure` (stores credentials in `~/.aws/credentials`)        |
| Environment vars| `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`                        |
| IAM Role        | For EC2 or container workloads with attached IAM roles              |
| Terraform Cloud | Set up environment variables/secrets in workspace settings          |

## 🔐 AWS CLI and Local Credential Storage

When you configure the AWS CLI using `aws configure`, it stores your credentials locally on your machine. These credentials are used directly form local by tools like Terraform, AWS CLI, SDKs, and other automation tools to authenticate to your AWS account.

## ⚙️ Terraform Workflow

```bash
terraform init      # Initialize the provider and download plugins
terraform plan      # Preview what resources will be created/changed
terraform apply     # Actually provisions the infrastructure
```

When you run `terraform apply`:
- Terraform sends **authenticated API requests to AWS**
- AWS responds and provisions the requested resources
- Terraform writes the resource info (IDs, attributes) into the `terraform.tfstate` file


## 🧠 Terraform State File

Terraform tracks everything it creates in a `terraform.tfstate` file.

It stores:
- The current state of your infrastructure
- AWS resource IDs and metadata
- Dependency graphs for future changes

You can store this file:
- Locally (default)
- In a remote backend (S3, Terraform Cloud, etc.) for team access and safety


## 📡 Real Workflow: EC2 Example

1. You write .tf file defining EC2 instance
2. Terraform CLI uses your AWS credentials
3. Terraform sends API request to AWS (EC2 API)
4. AWS provisions the EC2 instance
5. Terraform stores EC2 ID and details in terraform.tfstate


## 🔍 FAQs

| Question | Answer |
|---------|--------|
| How does Terraform talk to AWS? | Through AWS API calls using your credentials |
| Does AWS know you're using Terraform? | No — AWS just sees API requests |
| Where does Terraform remember what it created? | In the `terraform.tfstate` file |
| What happens if I lose my state file? | Terraform forgets everything it managed — use remote backends! |


## ✅ Summary

- Terraform is an **infrastructure as code (IaC)** tool.
- It uses your AWS credentials to **call AWS APIs** and create resources.
- Terraform keeps track of what it creates in a **state file**.
- It only makes changes when you run `terraform apply`.



## 📘 Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)

