output "primary_ip" {
  description = "Server primary ip"
  value       = hcloud_primary_ip.primary_ip_1.ip_address
}
