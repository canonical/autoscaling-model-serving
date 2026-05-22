resource "juju_model" "as_model_server" {
  count = var.create_model ? 1 : 0
  name  = var.model

  config = {
    juju-http-proxy  = var.http_proxy
    juju-https-proxy = var.https_proxy
    juju-no-proxy    = var.no_proxy
  }
}
