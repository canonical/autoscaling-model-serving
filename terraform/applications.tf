module "istio_ingressgateway" {
  source   = "git::https://github.com/canonical/istio-operators//charms/istio-gateway/terraform?ref=track/1.22"
  model    = var.create_model ? juju_model.as_model_server[0].name : local.model
  app_name = "istio-ingressgateway"
  config = {
    kind = "ingress",
  }
  revision = var.istio_ingressgateway_revision
}

module "istio_pilot" {
  source = "git::https://github.com/canonical/istio-operators//charms/istio-pilot/terraform?ref=track/1.22"
  model  = var.create_model ? juju_model.as_model_server[0].name : local.model
  config = {
    default-gateway = var.istio_default_gateway,
  }
  revision = var.istio_pilot_revision
}

module "knative_operator" {
  source   = "git::https://github.com/canonical/knative-operators//charms/knative-operator//terraform?ref=track/1.12"
  model    = var.create_model ? juju_model.as_model_server[0].name : local.model
  revision = var.knative_operator_revision
}

module "knative_serving" {
  source = "git::https://github.com/canonical/knative-operators//charms/knative-serving//terraform?ref=track/1.12"
  model  = var.create_model ? juju_model.as_model_server[0].name : local.model
  config = {
    "istio.gateway.namespace" = var.create_model ? juju_model.as_model_server[0].name : local.model,
    "istio.gateway.name"      = var.istio_default_gateway,
    namespace                 = "knative-serving",
  }
  revision = var.knative_serving_revision
}

module "kserve_controller" {
  source = "git::https://github.com/canonical/kserve-operators//charms/kserve-controller//terraform?ref=track/0.13"
  model  = var.create_model ? juju_model.as_model_server[0].name : local.model
  config = {
    deployment-mode = "serverless",
  }
  revision = var.kserve_controller_revision
}
