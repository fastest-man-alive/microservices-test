terraform{
    required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.36.1"
    }
    }
    backend "gcs"{
        bucket = "your-bucket"  #update bucket name here
        prefix = "terraform/state"
    }
}

provider "google" {
    impersonate_service_account = "your-sa-name"
    project = var.project
    region = var.region
}