terraform{
    required_providers {
    google = {
      source = "hashicorp/google"
      version = "6.36.1"
    }
    }
    backend "gcs"{
        bucket = "terraform-state-file-bucket-ps"  #update bucket name here
        prefix = "terraform/state"
    }
}

provider "google" {
    impersonate_service_account = "jenkins-sa@microservices-test-ps.iam.gserviceaccount.com"
    project = var.project
    region = var.region
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
}