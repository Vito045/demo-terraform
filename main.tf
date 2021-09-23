terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "3.1.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAYMJIZ6GH363RHNRP"
  secret_key = file("../secret_key.txt")
}

provider "cloudflare" {
  email = "vito045@icloud.com"
  token = file("../cloudflare_token.txt")
}
