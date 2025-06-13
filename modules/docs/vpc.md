# VPC Module Explanation

### 1. main.tf

```hcl
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = {
    Name = "public-subnet"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
```

1. `aws_vpc.main`: Creates a new VPC (Virtual Private Cloud) with the CIDR block provided via the variable var.vpc_cidr.
2. Tags the VPC with the name "main-vpc" for easy identification.
3. `aws_subnet.public`: Creates a public subnet inside the created VPC.
4. Uses CIDR block and availability zone from variables var.subnet_cidr and var.availability_zone.
5. map_public_ip_on_launch = true ensures instances launched in this subnet automatically get a public IP.
6. Tags the subnet `"public-subnet"`.
7. `aws_internet_gateway.igw`: Creates an Internet Gateway and attaches it to the VPC.
8. This gateway enables internet access for resources in the VPC.
9. `aws_route_table.public`: Creates a route table associated with the VPC.
10. Adds a route to send all internet-bound traffic `(0.0.0.0/0)` to the internet gateway `(aws_internet_gateway.igw.id)`.
11. This route enables instances in the subnet to access the internet.
12. `aws_route_table_association.public`: Associates the public subnet with the public route table.
13. This makes the subnet a public subnet (because it has a route to the internet gateway).

---

### 2. outputs.tf
```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_id" {
  value = aws_subnet.public.id
}
```

1. Outputs the IDs of the created VPC and public subnet.
2. These outputs are useful when referencing the VPC and subnet in other modules or the root module.

---

### 3. variables.tf

```hcl
variable "vpc_cidr" {}
variable "subnet_cidr" {}
variable "availability_zone" {}
```

Declares three input variables:

1. `vpc_cidr`: The CIDR block for the VPC (e.g., "10.0.0.0/16").
2. `subnet_cidr`: The CIDR block for the public subnet within the VPC (e.g., "10.0.1.0/24").
3. `availability_zone`: The AWS availability zone where the subnet will be created (e.g., "us-east-1a").

---

### Summary for VPC Module

**Purpose: Create a basic networking environment in AWS including**

1. A VPC
2. A public subnet inside the VPC
3. An internet gateway for outbound internet access
4. A route table that routes traffic to the internet gateway   
   - Association of the public subnet with the route table, making it a public subnet
   - Key outputs: VPC ID and Subnet ID, to use in other modules (e.g., EC2 instances).
   - Variables: Used to parameterize CIDR blocks and availability zone, allowing flexible deployment.

