# Terraform Architecture Setup

## Overview

This repository demonstrates how to set up infrastructure using Terraform in two different approaches:  
- **Arch1**: Using standard Terraform resources.  
- **Arch2**: Using Terraform modules to achieve better reusability and maintainability.  

Both architectures deploy similar resources, allowing for a direct comparison between the two methodologies.

## Architecture Comparison

| Feature  | Arch1 (Normal Resources) | Arch2 (Modules) |
|----------|-------------------------|-----------------|
| **Resource Definition** | Each resource is defined explicitly within Terraform configuration files. | Resources are abstracted into reusable modules. |
| **Reusability** | Low | High |
| **Maintainability** | Manual updates required for each resource. | Modules allow centralized updates. |
| **Scalability** | Can be cumbersome for large infrastructures. | Easier to scale and modify. |

---

## Project Structure

```
├── arch1
│   ├── main.tf
│   ├── my-keypair
│   ├── my-keypair.pub
│   ├── outputs.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.1741901968.backup
│   ├── terraform.tfstate.backup
│   ├── terraform.tfvars
│   └── variables.tf
├── arch2
│   ├── backend.tf
│   ├── main.tf
│   ├── modules
│   │   ├── ec2
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   ├── internet_gateway
│   │   ├── security-group
│   │   │   ├── main.tf
│   │   │   ├── outputs.tf
│   │   │   └── variables.tf
│   │   └── vpc
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   ├── my-key.pem
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   ├── terraform.tfvars
│   └── variables.tf
└── README.md
```

---

## Screenshots & Explanation

### **1. Standard Resources (Arch1)**
  
![WhatsApp Image 2025-03-13 at 15 25 37_07962040](https://github.com/user-attachments/assets/5790d07a-4f40-422f-a71a-97593dfa3cbd)




---

### **2. Modular Approach (Arch2)**


#### Running Nginx Machine
![WhatsApp Image 2025-03-13 at 22 16 59_4a0484c9](https://github.com/user-attachments/assets/f073bba2-753d-47e5-872c-c3eae3e4fc39)



#### 4. Sharing state file


###### 4.1. Implementing Remote State Storage

You will modify Terraform to store the state in **S3** and enable locking using **DynamoDB**.

 Step 1: Create an S3 Bucket for State Storage

Run the following AWS CLI command (or create it manually in AWS Console):

```sh
aws s3api create-bucket --bucket my-terraform-state-bucket --region us-east-1 --create-bucket-configuration LocationConstraint=us-east-1

```

Enable versioning for backup purposes:

```sh
aws s3api put-bucket-versioning --bucket my-terraform-state-bucket --versioning-configuration Status=Enabled

```

 Step 2: Create a DynamoDB Table for State Locking
```sh
aws dynamodb create-table \
    --table-name terraform-locks \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5

```
 
Step 3: Create backend.tf file and configure it
```hcl
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "arch2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
```
Step 4: Reinitialize Terraform
```sh
terraform init
```
Terraform will detect the backend change and ask whether to migrate the existing state to S3.
Type "yes" to confirm.










#### Destorying Terraform without deleting EC2 instance
![WhatsApp Image 2025-03-13 at 23 41 59_eccd3b6e](https://github.com/user-attachments/assets/b65b6651-93aa-4fc9-8c0a-d08833383c72)



#### Arch1: Prevent NAT Gateway deletion
![WhatsApp Image 2025-03-13 at 23 48 12_d5fde479](https://github.com/user-attachments/assets/ad72e414-08b6-471b-b524-f63a979a2af3)


