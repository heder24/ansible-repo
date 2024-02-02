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

source "amazon-ebs" "web-nginx" {
  ami_name = "packer-nginx-${local.timestamp}"
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
    owners      = ["099720109477"]  
  }
  ssh_username = "ubuntu"
  tags = {
    Name = "packer-nginx-${local.timestamp}"
  }
}

build {
  name    = "packer-web-nginx"
  sources = ["source.amazon-ebs.web-nginx"]

  provisioner "ansible" {
    playbook_file    = "../playbooks/nginx-install.yml"
    ansible_env_vars = ["ANSIBLE_CONFIG=ansible.cfg"]
    extra_arguments  = ["-vvvv"]
    user             = "ubuntu"
  }
}
