terraform {
  cloud {
    organization = "YtseJam"

    workspaces {
      name = "ansible-server"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.72.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "2.2.0"
    }
  }
  required_version = "~>1.1.3"
}

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "YtseJam"
    workspaces = {
      name = var.tfc_vpc_workspace_name
    }
  }
}

provider "aws" {
  region = data.terraform_remote_state.vpc.outputs.aws_region
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  owners = ["amazon"]
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "dev_key"
  public_key = var.dev_key
}

# data "template_file" "user_data" {
#   template = file("cloud_init.yaml")
#   vars = {
#     ansible_key = "${var.ansible_key}"
#   }
# }

resource "aws_instance" "server" {
  count = 1

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  subnet_id              = data.terraform_remote_state.vpc.outputs.public_subnet_1[0]
  vpc_security_group_ids = data.terraform_remote_state.vpc.outputs.sg_ec2

  key_name = aws_key_pair.ssh_key.key_name

  user_data = templatefile("user_data.tftpl", { ansible_key = var.ansible_key })
  # user_data = data.template_file.user_data.rendered
}