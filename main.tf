terraform {
  cloud {
    organization = "YtseJam"

    workspaces {
      name = "ansible-server"
    }
  }

  required_providers {
    aws = {
      source     = "hashicorp/aws"
      version = "~>3.72.0"
    }
  }
  required_version = "~>1.1.3"
}

data "terraform_remote_state" "vpc" {
  backend = "remote"

  config = {
    organization = "YtseJam"
    worksworkspaces = {
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