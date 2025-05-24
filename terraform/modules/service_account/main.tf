resource "google_service_account" "this" {
  account_id   = var.account_id
  display_name = var.display_name
}

resource "google_project_iam_member" "roles" {
  for_each = toset(var.project_roles)

  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.this.email}"
}
