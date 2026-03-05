# Compute Instance deployed into VPC using cross-project image

# Data source to reference the VPC network
data "google_compute_network" "vpc" {
  name    = var.vpc_id
  project = var.project_id
}

# Data source to reference the image from another project
data "google_compute_image" "custom_image" {
  project     = var.image_project_id
  family      = "jetstream-security-ai-hub"
  most_recent = true
}

# Firewall rule to allow SSH, and HTTPS from your IP only
resource "google_compute_firewall" "allow_external_access" {
  name    = "${var.name}-firewall"
  network = data.google_compute_network.vpc.name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = var.ingress_ports
  }

  source_ranges = var.ingress_cidrs
  target_tags   = ["external-access"]

  description = "Allow ingress from authorized cidrs only"
}

resource "google_compute_firewall" "egress" {
  for_each = var.egress_rules_map

  name      = "${var.name}-egress-${replace(each.key, "_", "-")}"
  network   = data.google_compute_network.vpc.name
  project   = var.project_id
  direction = "EGRESS"

  allow {
    protocol = each.value.ip_protocol
    ports    = [tostring(each.value.from_port)]
  }

  destination_ranges = each.value.cidr_ipv4 != null ? [each.value.cidr_ipv4] : []
  target_tags        = ["external-access"]

  description = each.value.description
}

# Deny all other egress
resource "google_compute_firewall" "egress_deny_all" {
  name      = "${var.name}-egress-deny-all"
  network   = data.google_compute_network.vpc.name
  project   = var.project_id
  direction = "EGRESS"
  priority  = 65534

  deny {
    protocol = "all"
  }

  destination_ranges = ["0.0.0.0/0"]
  target_tags        = ["external-access"]

  description = "Deny all other outbound traffic"
}

# Compute Instance
resource "google_compute_instance" "instance" {
  name         = var.name
  machine_type = var.instance_type
  zone         = "${var.gcp_region}-${var.zone_suffix}"
  project      = var.project_id

  tags = concat(["external-access"], var.instance_tags)

  boot_disk {
    initialize_params {
      image = data.google_compute_image.custom_image.self_link
      size  = var.boot_disk_size_gb
      type  = var.boot_disk_type
    }
  }

  network_interface {
    # Reference the subnet by name
    subnetwork         = var.subnet_id
    subnetwork_project = var.project_id

    # Assign external IP (required for internet access)
    access_config {
      nat_ip       = var.static_external_ip
      network_tier = var.network_tier
    }
  }

  # Service account with scopes
  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  # Metadata
  metadata = {
    enable-oslogin = var.enable_os_login
    ssh-keys       = "${var.ssh_user}:${var.ssh_public_key}"
    user-data = templatefile("${path.module}/cloud-init.yaml", {
      ai_hub_id        = var.jetstream_ai_hub_id
      gateway_endpoint = var.gateway_endpoint
      cert_public      = var.cert_public != null ? var.cert_public : ""
      cert_private     = var.cert_private != null ? var.cert_private : ""
    })
  }

  # Allow stopping for updates
  allow_stopping_for_update = true

  # Labels
  labels = var.tags

  # Lifecycle settings
  lifecycle {
    ignore_changes = []
  }
}
