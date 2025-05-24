variable "project"{
    description = "The GCP project ID"
    type        = string
}

variable "network_name"{
    description = "The name of the VPC network"
    type        = string
}

variable "routing_mode"{
    description = "The routing mode of the network"
    type        = string
    default     = "REGIONAL"
}

variable "subnets"{
    description = "List of subnets with optional secondary ranges"
    type        = list(object({
        name = string
        cidr = string
        region = string
        private_ip_google_access = optional(bool)
        secondary_ip_ranges = optional(list(object({
            name = string
            cidr = string
        })))
    }))
}

variable "firewall_rules"{
    description = "List of firewall rules to create"
    type = list(object({
        name = string
        direction = string
        priority = optional(number)
        allow = optional(list(object({
            protocol = string
            ports = list(string)
        })))
        deny = optional(list(object({
            protocol = string
            ports = list(string)
        })))
        source_ranges = optional(list(string))
        destination_ranges = optional(list(string))
        target_tags = optional(list(string))
        disabled = optional(bool)
    }))
}