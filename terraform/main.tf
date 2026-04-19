resource "juju_model" "as_model_server" {
  count = var.create_model ? 1 : 0
  name  = var.model
}

locals {
  istio_track   = "1.28"
  knative_track = "1.16"
  kserve_track  = "0.17"
}
