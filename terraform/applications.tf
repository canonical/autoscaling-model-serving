module "istio_ingressgateway" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-gateway/terraform?ref=track/${local.istio_track}"
  model_name = var.create_model ? juju_model.as_model_server[0].name : var.model
  app_name   = "istio-ingressgateway"
  config     = {
    kind = "ingress",
  }
  revision   = var.istio_ingressgateway_revision
  channel    = "${local.istio_track}/${var.risk}"
}

module "istio_pilot" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-pilot/terraform?ref=track/${local.istio_track}"
  model_name = var.create_model ? juju_model.as_model_server[0].name : var.model
  config     = {
    default-gateway = var.istio_default_gateway,
  }
  revision   = var.istio_pilot_revision
  channel    = "${local.istio_track}/${var.risk}"
}

module "knative_operator" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-operator//terraform?ref=track/${local.knative_track}"
  model_name = var.create_model ? juju_model.as_model_server[0].name : var.model
  revision   = var.knative_operator_revision
  channel    = "${local.knative_track}/${var.risk}"
}

module "knative_serving" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-serving//terraform?ref=track/${local.knative_track}"
  model_name = var.create_model ? juju_model.as_model_server[0].name : var.model
  config     = {
    "istio.gateway.namespace" = var.create_model ? juju_model.as_model_server[0].name : var.model,
    "istio.gateway.name"      = var.istio_default_gateway,
  }
  revision   = var.knative_serving_revision
  channel    = "${local.knative_track}/${var.risk}"
}

module "kserve_controller" {
  source     = "git::https://github.com/canonical/kserve-operators//charms/kserve-controller//terraform?ref=track/${local.kserve_track}"
  model_name = var.create_model ? juju_model.as_model_server[0].name : var.model
  config     = {
    deployment-mode = "knative",
  }
  revision   = var.kserve_controller_revision
  channel    = "${local.kserve_track}/${var.risk}"
}
