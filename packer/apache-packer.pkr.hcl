packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "web-apache" {
  ami_name = "packer-apache-${local.timestamp}"
  instance_type = "t2.micro"
  region = "us-east-2"
  profile = "default"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]  # Canonical AWS Marketplace account ID
  }
  ssh_username = "ubuntu"
  tags = {
    Name = "packer-apache-${local.timestamp}"
  }
}

build {
  name    = "packer-web-apache"
  sources = ["source.amazon-ebs.web-apache"]

  provisioner "ansible" {
    playbook_file    = "../playbooks/apache-install.yml"
    ansible_env_vars = ["ANSIBLE_CONFIG=ansible.cfg"]
    # inventory_file   = "aws_ec2.yaml"
    extra_arguments  = ["-vvvv"]
    user             = "ubuntu"
  }
}
