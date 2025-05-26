# Reserve a global static IP
resource "google_compute_global_address" "gke_ingress_ip" {
  name = "gke-ingress-static-ip"
  project = var.project
}