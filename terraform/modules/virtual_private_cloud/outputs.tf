output "network_name" {
  value = google_compute_network.vpc_network.name
}

output "subnets" {
  value = google_compute_subnetwork.subnetworks
}

output "region" {
  value = google_compute_subnetwork.subnetworks.region
}