resource "google_container_cluster" "gke" {
  name                     = var.cluster_name
  location                 = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  network                  = var.network
  subnetwork               = var.subnetwork
  networking_mode          = "VPC_NATIVE"

  deletion_protection = false

  # Optional, if you want multi-zonal cluster
  # node_locations = ["us-central1-b"]

  addons_config {
    http_load_balancing {
      disabled = true
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  release_channel {
    channel = var.release_channel
  }

  workload_identity_config {
    workload_pool = "${var.project}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pod_range_name
    services_secondary_range_name = var.service_range_name
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "192.168.0.0/28"
  }

  # Jenkins use case
  # master_authorized_networks_config {
  #   cidr_blocks {
  #     cidr_block   = "10.0.0.0/18"
  #     display_name = "private-subnet"
  #   }
  # }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  location   = var.region
  cluster    = google_container_cluster.gke.name
  project    = var.project

  node_config {
    machine_type = var.machine_type
    disk_size_gb = var.disk_size
    labels = var.node_labels
    tags = var.node_tags

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = var.service_account
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  initial_node_count = var.initial_node_count
  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair = true
    auto_upgrade = true
  }
}