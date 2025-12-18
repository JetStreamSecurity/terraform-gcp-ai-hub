terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = ">= 2.3"
    }
  }
}

provider "google" {
  project = "my-gcp-project-id"
  region  = "us-central1"
}

module "jetstream_ai_hub" {
  source = "github.com/JetStreamSecurity/terraform-gcp-ai-hub"

  name                  = "my-ai-hub"
  project_id            = "my-gcp-project-id"
  vpc_id                = "vpc-12345678"
  subnet_id             = "subnet-1"
  jetstream_gateway_key = "your-gateway-key-here"
  ingress_cidrs         = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  cert_public           = base64encode(file("/tmp/public_cert.crt"))
  cert_private          = base64encode(file("/tmp/private_cert.key"))

  tags = {
    Environment = "production"
    Project     = "security"
  }
}
