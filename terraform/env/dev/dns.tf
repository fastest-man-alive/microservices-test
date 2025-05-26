# Create DNS Managed Zone
resource "google_dns_managed_zone" "example_zone" {
  name        = "kubernetes-zone"
  dns_name    = "example.com."  # Note the trailing dot
  project     = var.project
  description = "Kubernetes DNS zone"
}

# Create an A record
resource "google_dns_record_set" "example_a_record" {
  name         = "www.mymicroserviceps.com."
  type         = "A"
  ttl          = 300
  managed_zone = google_dns_managed_zone.example_zone.name
  project     = var.project
  rrdatas = [google_compute_global_address.gke_ingress_ip.address]
}