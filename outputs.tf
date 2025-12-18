# Outputs for GCP Compute Instance

output "instance_name" {
  description = "Name of the instance"
  value       = google_compute_instance.instance.name
}

output "instance_id" {
  description = "ID of the instance"
  value       = google_compute_instance.instance.instance_id
}

output "instance_self_link" {
  description = "Self-link of the instance"
  value       = google_compute_instance.instance.self_link
}

output "instance_zone" {
  description = "Zone where the instance is deployed"
  value       = google_compute_instance.instance.zone
}

output "internal_ip" {
  description = "Internal IP address of the instance"
  value       = google_compute_instance.instance.network_interface[0].network_ip
}

output "external_ip" {
  description = "External IP address of the instance"
  value       = google_compute_instance.instance.network_interface[0].access_config[0].nat_ip
}

output "firewall_rule_name" {
  description = "Name of the firewall rule allowing external access"
  value       = google_compute_firewall.allow_external_access.name
}

output "allowed_ports" {
  description = "Ports allowed through the firewall"
  value       = ["22", "4000", "443"]
}

output "allowed_ip" {
  description = "IP address/CIDR allowed to access the instance"
  value       = var.ingress_cidrs
}

output "image_used" {
  description = "Full image reference used for the instance"
  value       = data.google_compute_image.custom_image.self_link
}

output "image_name" {
  description = "Name of the image used"
  value       = data.google_compute_image.custom_image.name
}

output "image_project" {
  description = "Project ID where the image is located"
  value       = data.google_compute_image.custom_image.project
}

output "service_account_email" {
  description = "Service account email attached to the instance"
  value       = google_compute_instance.instance.service_account[0].email
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "gcloud compute ssh ${google_compute_instance.instance.name} --zone=${google_compute_instance.instance.zone} --project=${var.project_id}"
}

output "ssh_direct_command" {
  description = "Direct SSH command using the external IP"
  value       = "ssh ${var.ssh_user}@${google_compute_instance.instance.network_interface[0].access_config[0].nat_ip}"
}

output "ssh_user" {
  description = "SSH username configured for the instance"
  value       = var.ssh_user
}
