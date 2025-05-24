module "my-cluster"{
    source            = "../../modules/kubernetes"
    project           = var.project
    region            = var.region
    cluster_name      = "my-cluster"
    network           = module.kubernetes_vpc.network_name
    subnetwork        = module.kubernetes_vpc.subnets[0].name
    service_account   = module.k8s_service_account.email
    release_channel   = "REGULAR"
    machine_type      = "e2-small"
    disk_size         = 50
    initial_node_count= 1
    min_node_count    = 1
    max_node_count    = 2
    node_labels       = { env="dev"}
    node_tags         = ["gke-node"]
}