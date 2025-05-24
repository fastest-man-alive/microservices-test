module "kubernetes_vpc"{
    source = "../../modules/virtual_private_cloud"
    project = var.project
    network_name = "kubernetes_vpc"
    routing_mode = "REGIONAL"

    subnets = [
        {
            name = "private-subnet"
            region = "asia-south1"
            cidr  = "10.10.0.0/16"
            secondary_ip_ranges = [
                {
                    name = "pods"
                    cidr = "10.20.0.0/16"
                },
                {
                    name = "services"
                    cidr = "10.30.0.0/16"
                }
            ]
        }
    ]

    firewall_rules = [
        {
            name = "allow-ssh"
            direction = "INGRESS"
            source_ranges = ["0.0.0.0/0"]
            allow = [
                {
                    protocol = "tcp"
                    ports = ["22"]
                }
            ]
        },
        {
            name = "allow-http"
            direction = "INGRESS"
            source_ranges = ["0.0.0.0/0"]
            allow = [
                {
                    protocol = "tcp"
                    ports = ["80","8080","443","9090","7000","7001","7002"]
                }
            ]
        }
    ]
}