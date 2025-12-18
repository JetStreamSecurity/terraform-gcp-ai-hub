# terraform-gcp-ai-hub

This Terraform module deploys a JetStream Security AI-Hub Compute Engine instance on Google Cloud Platform with associated networking, firewall, and service account configurations.

## Features

- **Automated Image Selection**: Automatically selects the latest JetStream AI-Hub image from a specified project
- **Cloud-Init Integration**: Configures the instance using cloud-init with JetStream Gateway key
- **Firewall Management**: Creates a dedicated firewall rule with customizable ingress rules
- **Service Account Configuration**: Supports custom service account attachment with configurable scopes
- **Boot Disk Options**: Supports different disk types (pd-standard, pd-balanced, pd-ssd) with customizable size
- **OS Login Support**: Configurable OS Login or direct SSH key authentication
- **Flexible Networking**: Supports static external IP assignment and custom network tiers
- **Network Tags**: Flexible instance tagging for firewall targeting

## Prerequisites

- Terraform >= 1.0
- Google Cloud Provider configured with appropriate credentials
- VPC network and subnet pre-created
- JetStream Gateway Key for AI-Hub configuration
- SSH public key for instance access

## Usage

### Basic Example

```hcl
module "jetstream_ai_hub" {
  source = "github.com/JetStreamSecurity/terraform-gcp-ai-hub"

  name                   = "my-ai-hub"
  project_id             = "my-gcp-project"
  vpc_id                 = "my-vpc-network"
  subnet_id              = "my-subnet"
  jetstream_gateway_key  = "your-gateway-key-here"
  ingress_cidrs          = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  ssh_public_key         = file("~/.ssh/id_rsa.pub")
  ssh_user               = "ubuntu"
  cert_public            = base64encode(file("/tmp/public_cert.crt"))
  cert_private           = base64encode(file("/tmp/private_cert.key"))

  tags = {
    environment = "production"
    project     = "security"
  }
}
```

### Advanced Example with Custom Configuration

```hcl
module "jetstream_ai_hub" {
  source = "github.com/JetStreamSecurity/terraform-gcp-ai-hub"

  name                   = "ai-hub-prod"
  project_id             = "production-project-123"
  image_project_id       = "js-engineering-480823"
  
  # Networking
  vpc_id                 = "production-vpc"
  subnet_id              = "us-central1-private-subnet"
  ingress_cidrs          = ["10.0.0.0/8"]
  static_external_ip     = "34.123.45.67"
  network_tier           = "PREMIUM"
  
  # Compute Configuration
  instance_type          = "n1-standard-4"
  gcp_region             = "us-central1"
  zone_suffix            = "b"
  boot_disk_type         = "pd-ssd"
  boot_disk_size_gb      = 200
  
  # SSH Configuration
  ssh_public_key         = file("~/.ssh/production_key.pub")
  ssh_user               = "admin"
  enable_os_login        = "FALSE"
  
  # JetStream Configuration
  jetstream_gateway_key  = var.gateway_key
  cert_public            = base64encode(file("/certs/public.crt"))
  cert_private           = base64encode(file("/certs/private.key"))
  
  # Service Account
  service_account_email  = "ai-hub-sa@production-project-123.iam.gserviceaccount.com"
  service_account_scopes = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
  
  # Additional network tags
  instance_tags = ["ai-hub", "production"]
  
  tags = {
    environment = "production"
    managed_by  = "terraform"
    team        = "security"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| google | >= 5.0 |
| cloudinit | >= 2.3 |

## Providers

| Name | Version |
|------|---------|
| google | >= 5.0 |
| cloudinit | >= 2.3 |

## Resources

| Name | Type |
|------|------|
| google_compute_network.vpc | data source |
| google_compute_image.custom_image | data source |
| google_compute_firewall.allow_external_access | resource |
| google_compute_instance.instance | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name to be used on Compute Engine instance and related resources | `string` | n/a | yes |
| project_id | GCP Project ID where the instance will be deployed | `string` | n/a | yes |
| vpc_id | VPC network name where the instance will be deployed | `string` | n/a | yes |
| subnet_id | Subnet name where the instance will be deployed | `string` | n/a | yes |
| jetstream_gateway_key | JetStream Gateway key for AI-Hub configuration | `string` | n/a | yes |
| ssh_public_key | SSH public key for instance access | `string` | n/a | yes |
| ingress_cidrs | List of CIDR blocks allowed to access the instance | `list(string)` | n/a | yes |
| image_project_id | GCP Project ID where the custom image is located | `string` | `"js-engineering-480823"` | no |
| ssh_user | SSH username for the key | `string` | `"ubuntu"` | no |
| gcp_region | GCP region for the instance | `string` | `"us-central1"` | no |
| zone_suffix | Zone suffix (a, b, c, etc.) | `string` | `"a"` | no |
| static_external_ip | Optional static external IP address to assign | `string` | `null` | no |
| network_tier | Network tier for external IP (PREMIUM or STANDARD) | `string` | `"STANDARD"` | no |
| instance_tags | Network tags for the instance (used for firewall rules) | `list(string)` | `[]` | no |
| boot_disk_size_gb | Size of the boot disk in GB | `number` | `100` | no |
| boot_disk_type | Type of boot disk (pd-standard, pd-balanced, pd-ssd) | `string` | `"pd-balanced"` | no |
| service_account_email | Service account email to attach to the instance | `string` | `null` | no |
| service_account_scopes | Service account scopes | `list(string)` | `["https://www.googleapis.com/auth/cloud-platform"]` | no |
| enable_os_login | Enable OS Login for the instance (FALSE when using SSH keys directly) | `string` | `"FALSE"` | no |
| cert_public | Public certificate for AI-Hub (base64 encoded) | `string` | `null` | no |
| cert_private | Private key for AI-Hub certificate (base64 encoded) | `string` | `null` | no |
| instance_type | Machine type to use for the instance | `string` | `"n1-standard-2"` | no |
| ingress_ports | Ingress ports for the firewall (note: currently hardcoded to 22, 4000, 443) | `list(string)` | `["4000", "443"]` | no |
| tags | Map of labels to assign to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance_name | Name of the instance |
| instance_id | ID of the instance |
| instance_self_link | Self-link of the instance |
| instance_zone | Zone where the instance is deployed |
| internal_ip | Internal IP address of the instance |
| external_ip | External IP address of the instance |
| firewall_rule_name | Name of the firewall rule allowing external access |
| allowed_ports | Ports allowed through the firewall |
| allowed_ip | IP address/CIDR blocks allowed to access the instance |
| image_used | Full image reference used for the instance |
| image_name | Name of the image used |
| image_project | Project ID where the image is located |
| service_account_email | Service account email attached to the instance |
| ssh_command | Command to SSH into the instance using gcloud |
| ssh_direct_command | Direct SSH command using the external IP |
| ssh_user | SSH username configured for the instance |

## Module Structure

The module expects the following structure:

```bash
.
├── main.tf              # Main resource definitions
├── variables.tf         # Input variable definitions
├── outputs.tf           # Output definitions
├── cloud-init.yaml      # Cloud-init configuration template
├── versions.tf          # Provider version constraints
└── README.md            # This file
```

## Security Considerations

### Firewall Configuration

- The module creates a dedicated firewall rule that allows TCP ports 22 (SSH), 4000, and 443 (HTTPS)
- Firewall rules are scoped to instances with the `external-access` network tag
- Source IP ranges should be restricted to trusted networks only

### SSH Authentication

- OS Login is disabled by default to support direct SSH key authentication
- SSH keys are configured via instance metadata
- Consider enabling OS Login for centralized access management in production environments

### Service Account

- The module supports attaching a custom service account to the instance
- Default scopes provide full cloud-platform access - consider restricting in production
- Follow the principle of least privilege when configuring service account permissions

### Network Security

- External IP addresses are assigned by default for internet connectivity
- Consider using Cloud NAT for private instances that don't require direct internet access
- Network tier defaults to STANDARD - use PREMIUM for lower latency requirements

### Boot Disk

- Boot disks default to pd-balanced for cost-effective performance
- Consider using pd-ssd for higher performance requirements
- Google Cloud encrypts all data at rest by default using Google-managed keys

## Notes

- Image selection filters for images in the `jetstream-security-ai-hub` family
- The instance is configured with `allow_stopping_for_update = true` for maintenance flexibility
- Firewall ports are currently hardcoded to 22, 4000, and 443
- The module uses cloud-init for instance initialization with JetStream Gateway configuration

## SSH Access

After deployment, you can access the instance using either:

1. **Using gcloud CLI** (recommended):

   ```bash
   gcloud compute ssh <instance-name> --zone=<zone> --project=<project-id>
   ```

2. **Direct SSH**:

   ```bash
   ssh <ssh-user>@<external-ip>
   ```

The module outputs provide these commands with values pre-filled for convenience.

## Examples

### Minimal Configuration

```hcl
module "ai_hub" {
  source = "github.com/JetStreamSecurity/terraform-gcp-ai-hub"

  name                  = "ai-hub-dev"
  project_id            = "dev-project-123"
  vpc_id                = "default"
  subnet_id             = "default"
  jetstream_gateway_key = var.gateway_key
  ssh_public_key        = file("~/.ssh/id_rsa.pub")
  ingress_cidrs         = ["0.0.0.0/0"]  # Not recommended for production
}
```

### Production Configuration with High Performance

```hcl
module "ai_hub" {
  source = "github.com/JetStreamSecurity/terraform-gcp-ai-hub"

  name                  = "ai-hub-prod"
  project_id            = "production-project"
  vpc_id                = "production-vpc"
  subnet_id             = "prod-subnet"
  
  # High-performance configuration
  instance_type         = "n2-standard-8"
  boot_disk_type        = "pd-ssd"
  boot_disk_size_gb     = 500
  network_tier          = "PREMIUM"
  
  # Security
  jetstream_gateway_key = var.gateway_key
  ssh_public_key        = file("~/.ssh/prod_key.pub")
  ssh_user              = "admin"
  ingress_cidrs         = ["10.0.0.0/16"]
  
  # Service account with limited permissions
  service_account_email = google_service_account.ai_hub_sa.email
  service_account_scopes = [
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write"
  ]
  
  tags = {
    environment = "production"
    compliance  = "required"
  }
}
```

### Private Instance with Cloud NAT

```hcl
# Note: This example assumes Cloud NAT is configured separately

module "ai_hub" {
  source = "github.com/JetStreamSecurity/terraform-gcp-ai-hub"

  name                  = "ai-hub-private"
  project_id            = "private-project"
  vpc_id                = "private-vpc"
  subnet_id             = "private-subnet"
  
  # No external IP - requires Cloud NAT for outbound connectivity
  static_external_ip    = null
  
  jetstream_gateway_key = var.gateway_key
  ssh_public_key        = file("~/.ssh/id_rsa.pub")
  
  # Restrict to internal network only
  ingress_cidrs         = ["10.0.0.0/8"]
  
  tags = {
    environment = "secure"
    internal    = "true"
  }
}
```

## Contributing

When contributing to this module:

1. Follow Terraform best practices and Google Cloud conventions
2. Update documentation for any variable changes
3. Test with `terraform validate` and `terraform plan`
4. Consider backward compatibility
5. Ensure all outputs are properly documented

## Troubleshooting

### Instance Cannot Access Internet

- Verify that the subnet has a route to the internet gateway or Cloud NAT is configured
- Check that firewall rules allow egress traffic
- Confirm that an external IP is assigned (if not using Cloud NAT)

### SSH Connection Issues

- Verify that `ingress_cidrs` includes your current IP address
- Confirm that the SSH public key is correctly formatted
- Check that OS Login is disabled if using direct SSH key authentication
- Ensure the firewall rule has been created and applied

### Image Not Found

- Verify that `image_project_id` is correct and accessible
- Confirm that images exist in the `jetstream-security-ai-hub` family
- Check that your service account has permissions to access images in the specified project

## License

[MIT]

## Changelog

### Version 0.1.0

- Initial release
- Support for Compute Engine instance deployment
- Firewall rule management
- Cloud-init integration
- Cross-project image support
- Service account configuration
