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

variable "image_name" {
  description = "Name of the custom image to use"
  type        = string
  default     = "jetstream-security-ai-hub-1765516650-dev-latest"
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
  default     = 100
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

variable "additional_metadata" {
  description = "Additional metadata key-value pairs"
  type        = map(string)
  default     = {}
}

variable "startup_script" {
  description = "Startup script to run on instance boot"
  type        = string
  default     = null
}

variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
  default     = {}
}


#----------------------------------
#----------------------------------
#----------------------------------
#----------------------------------
#----------------------------------
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

variable "jetstream_gateway_key" {
  description = "JetStream Gateway Key for AI Hub configuration"
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
# Instance Configuration
variable "instance_type" {
  description = "Instance type to use for the instance"
  type        = string
  default     = "n1-standard-2"
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with the instance"
  type        = bool
  default     = false
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring (1-minute intervals)"
  type        = bool
  default     = false
}

# Cloud-Init / User Data Configuration
variable "user_data_replace_on_change" {
  description = "Whether to replace the instance when user data changes"
  type        = bool
  default     = false
}

variable "ingress_ports" {
  description = "Ingress ports for the security group"
  type        = list(string)
  default     = ["4000", "443"]
}

variable "additional_security_group_ids" {
  description = "List of additional security group IDs to attach to the instance"
  type        = list(string)
  default     = []
}

# IAM Configuration
variable "iam_policy_arns" {
  description = "List of IAM policy ARNs to attach to the instance role"
  type        = list(string)
  default     = []
}

variable "enable_ssm" {
  description = "Whether to enable AWS Systems Manager access"
  type        = bool
  default     = true
}

# Instance Metadata Configuration
variable "metadata_http_endpoint" {
  description = "Whether the metadata service is available (enabled or disabled)"
  type        = string
  default     = "enabled"
}

variable "metadata_http_tokens" {
  description = "Whether or not the metadata service requires session tokens (IMDSv2)"
  type        = string
  default     = "required"
}

variable "metadata_http_put_response_hop_limit" {
  description = "Desired HTTP PUT response hop limit for instance metadata requests"
  type        = number
  default     = 1
}

variable "metadata_instance_tags" {
  description = "Enables or disables access to instance tags from the instance metadata service"
  type        = string
  default     = "disabled"
}

# Root Volume Configuration
variable "root_volume_type" {
  description = "Type of root volume (gp3, gp2, io1, io2, st1, sc1)"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "Size of the root volume in GB"
  type        = number
  default     = 100 # minimum size for AI Hub
}

variable "root_volume_iops" {
  description = "IOPS for the root volume (only for gp3, io1, io2)"
  type        = number
  default     = null
}

variable "root_volume_throughput" {
  description = "Throughput for the root volume in MB/s (only for gp3)"
  type        = number
  default     = null
}

variable "root_volume_encrypted" {
  description = "Whether to encrypt the root volume"
  type        = bool
  default     = true
}

variable "root_volume_kms_key_id" {
  description = "KMS key ID to use for root volume encryption"
  type        = string
  default     = null
}

variable "root_volume_delete_on_termination" {
  description = "Whether the root volume should be deleted on instance termination"
  type        = bool
  default     = true
}

variable "root_volume_tags" {
  description = "Additional tags for the root volume"
  type        = map(string)
  default     = {}
}

# Tags
variable "tags" {
  description = "Map of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

locals {
  # Create all combinations of ports and CIDRs
  ingress_rules = flatten([
    for port in var.ingress_ports : [
      for cidr in var.ingress_cidrs : {
        port = port
        cidr = cidr
      }
    ]
  ])

  # Convert to map with unique keys for for_each
  ingress_rules_map = {
    for rule in local.ingress_rules :
    "${rule.port}-${replace(rule.cidr, "/", "_")}" => rule
  }
}
