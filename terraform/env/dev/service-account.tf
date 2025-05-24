module "k8s_service_account" {
  source       = "../../modules/service_account"
  project   = var.project
  account_id   = "kubernetes-sa"
  display_name = "Kubernetes Service Account"
  project_roles = [
    "roles/storage.admin",
    "roles/logging.logWriter"
  ]
}