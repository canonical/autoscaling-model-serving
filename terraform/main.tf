resource "juju_model" "as_model_server" {
  count = var.create_model ? 1 : 0
  name  = var.model
}
