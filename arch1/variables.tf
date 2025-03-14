variable "aws_region" {}
variable "vpc_cidr" {}
variable "public_subnet_cidr" {}
variable "private_subnet_cidr" {}
variable "instance_type" {}
variable "key_name" {}   # SSH Key for EC2 access
variable "nat_gateway_enabled" { default = true }
variable "public_key_path" {}  # Path to the public key file


variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}
