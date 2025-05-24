output "network_name" {
  value = google_compute_network.vpc.name
}

output "subnets" {
  value = google_compute_subnetwork.subnetworks
}