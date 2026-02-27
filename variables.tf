# Variables for GCP Compute Instance
variable "project_id" {
  description = "GCP Project ID where the instance will be deployed"
  type        = string
}

variable "image_project_id" {
  description = "GCP Project ID where the custom image is located"
  type        = string
  default     = "js-engineering-480823"
}

variable "ssh_public_key" {
  description = "Path to SSH public key file (e.g., '~/.ssh/id_rsa.pub')"
  type        = string
}

variable "ssh_user" {
  description = "SSH username for the key"
  type        = string
  default     = "ubuntu"
}

variable "gcp_region" {
  description = "GCP region for the instance"
  type        = string
  default     = "us-central1"
}

variable "zone_suffix" {
  description = "Zone suffix (a, b, c, etc.)"
  type        = string
  default     = "a"
}

variable "static_external_ip" {
  description = "Optional static external IP address to assign"
  type        = string
  default     = null
}

variable "network_tier" {
  description = "Network tier for external IP (PREMIUM or STANDARD)"
  type        = string
  default     = "STANDARD"
}

variable "instance_tags" {
  description = "Network tags for the instance (used for firewall rules)"
  type        = list(string)
  default     = []
}

variable "boot_disk_size_gb" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 1000 # minimum size is 100 for AI Hub
}

variable "boot_disk_type" {
  description = "Type of boot disk (pd-standard, pd-balanced, pd-ssd)"
  type        = string
  default     = "pd-balanced"
}

variable "service_account_email" {
  description = "Service account email to attach to the instance"
  type        = string
  default     = null
}

variable "service_account_scopes" {
  description = "Service account scopes"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

variable "enable_os_login" {
  description = "Enable OS Login for the instance. Set to FALSE when using SSH keys directly."
  type        = string
  default     = "FALSE"
}

# Required Variables
variable "ingress_cidrs" {
  description = "Ingress source cidr blocks for the security group"
  type        = list(string)
}

variable "name" {
  description = "Name to be used on EC2 instance and related resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the instance will be deployed"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be deployed"
  type        = string
}

variable "jetstream_ai_hub_id" {
  description = "JetStream AI-Hub id"
  type        = string
}

variable "cert_public" {
  description = "Public certificate for AI Hub"
  type        = string
  default     = null
}

variable "cert_private" {
  description = "Private key for AI Hub certificate"
  type        = string
  default     = null
}

# Optional Variables
variable "instance_type" {
  description = "Instance type to use for the instance"
  type        = string
  default     = "n2-standard-8"
}

variable "ingress_ports" {
  description = "Ingress ports for the security group"
  type        = list(string)
  default     = ["443"]
}

variable "gateway_endpoint" {
  description = "JetStream Gateway Endpoint"
  type        = string
  default     = "gateway.jetstream.security"
}

# Tags
variable "tags" {
  description = "Map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}
