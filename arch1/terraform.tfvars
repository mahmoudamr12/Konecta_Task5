aws_region         = "us-east-1"
vpc_cidr          = "10.0.0.0/16"
public_subnet_cidr  = "10.0.1.0/24"
private_subnet_cidr = "10.0.2.0/24"
instance_type      = "t2.micro"
key_name          = "my-keypair"
public_key_path   = "./my-keypair.pub"  # Path to the public key
ami_id = "ami-04b4f1a9cf54c11d0"  # Replace with a valid AMI
