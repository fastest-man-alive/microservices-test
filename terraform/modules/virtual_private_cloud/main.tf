resource "google_compute_network" "vpc_network" {
  project                         = var.project
  name                            = var.network_name
  routing_mode                    = var.routing_mode
  auto_create_subnetworks         = false
}

resource "google_compute_subnetwork" "subnetworks" {
  count                    = length(var.subnets)
  project                  = var.project
  name                     = var.subnets[count.index].name
  ip_cidr_range            = var.subnets[count.index].cidr
  region                   = var.subnets[count.index].region
  network                  = google_compute_network.vpc_network.id
  private_ip_google_access = true
  stack_type               = "IPV4_ONLY"
  secondary_ip_range {
    range_name    = var.subnets[count.index].secondary_ip_ranges.name
    ip_cidr_range = var.subnets[count.index].secondary_ip_ranges.cidr
  }
}

resource "google_compute_firewall" "fw_rules" {
  for_each= { for rule in var.firewall_rules : rule.name => rule}

  name    = each.value.name
  network = google_compute_network.vpc_network.name
  project = var.project

  direction = each.value.direction
  priority  = lookup(each.value, "priority", 1000)
  dynamic "allow" {
    for_each = lookup(each.value, "allow", [])
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }
  dynamic "deny"{
    for_each = lookup(each.value, "deny", [])
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }      

  source_ranges = lookup(each.value, "source_ranges", null)
  destination_ranges = lookup(each.value, "destination_ranges", null)
  target_tags = lookup(each.value, "target_tags", null)
  disabled   = lookup(each.value, "disabled", false)
}