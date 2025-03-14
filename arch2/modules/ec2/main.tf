resource "aws_instance" "nginx_instance" {
  ami             = var.ami_id  # Use variable instead of hardcoded AMI
  instance_type   = "t2.micro"
  key_name        = var.key_name
  subnet_id       = var.subnet_id
  security_groups = [var.sg_id]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "Public Nginx Server"
  }
}
