variable "project"{
    description = "Your GCP Project ID"
    type = string
}

variable "cluster_name"{
    description = "Kubernetes Cluster name"
    type = string
}

variable "region"{
    description = "GCP region where you want to deploy the resource"
    type = string
}

variable "network"{
    description = "VPC network"
    type = string
}

variable "subnetwork"{
    description = "Subnet where you want to deploy"
    type = string
}

variable "pod_range_name"{
    description = "Secondary range name for Pods"
    type = string
}

variable "service_range_name"{
    description = "Secondary range name for Services"
    type = string
}

variable "master_cidr_block"{
    description = "CIDR range for master node"
    type = string
}

variable "release_channel"{
    type = string
    default = "REGULAR"
}

variable "machine_type"{
    description = "Machine type of the nodes"
    type = string
    default = "e2-small"
}

variable "disk_size"{
    description = "Persistent storage for nodes"
    type = number #in GB
    default = 50
}

variable "node_labels"{
    type = map(string)
    default = {}
}

variable "node_tags"{
    type = list(string)
    default = []
}

variable "min_node_count"{
    type = number
    default = 1
}

variable "max_node_count"{
    type = number
    default = 2
}

variable "initial_node_count"{
    type = number
    default = 1
}

variable "service_account"{
    type = string
    description = "GCP Service Account assigned to K8s cluster"
}