module "istio_ingressgateway" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-gateway/terraform?ref=track/1.28"
  model_name = var.create_model ? juju_model.as_model_server[0].name : var.model
  app_name   = "istio-ingressgateway"
  config = {
    kind = "ingress",
  }
  revision = var.istio_ingressgateway_revision
  channel  = "1.28/${var.risk}"
}

module "istio_pilot" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-pilot/terraform?ref=track/1.28"
  model_name = var.create_model ? juju_model.as_model_server[0].name : var.model
  config = {
    default-gateway = var.istio_default_gateway,
  }
  revision = var.istio_pilot_revision
  channel  = "1.28/${var.risk}"
}

module "knative_operator" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-operator//terraform?ref=track/1.16"
  model_name = var.create_model ? juju_model.as_model_server[0].name : var.model
  revision   = var.knative_operator_revision
  channel    = "1.16/${var.risk}"
}

module "knative_serving" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-serving//terraform?ref=track/1.16"
  model_name = var.create_model ? juju_model.as_model_server[0].name : var.model
  config = {
    "istio.gateway.namespace" = var.create_model ? juju_model.as_model_server[0].name : var.model,
    "istio.gateway.name"      = var.istio_default_gateway,
  }
  revision = var.knative_serving_revision
  channel  = "1.16/${var.risk}"
}

module "kserve_controller" {
  source     = "git::https://github.com/canonical/kserve-operators//charms/kserve-controller//terraform?ref=track/0.17"
  model_name = var.create_model ? juju_model.as_model_server[0].name : var.model
  config = {
    deployment-mode = var.kserve_mode,
  }
  revision = var.kserve_controller_revision
  channel  = "0.17/edge"
}
