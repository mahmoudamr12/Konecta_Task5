terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-mahmoud-12345"
    key            = "arch2/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
