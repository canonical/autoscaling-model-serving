module "istio_ingressgateway" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-gateway/terraform?ref=track/1.22"
  model_name = var.model_name
  app_name   = "istio-ingressgateway"
  config = {
    kind = "ingress",
  }
  revision = var.istio_ingressgateway_revision
}

module "istio_pilot" {
  source     = "git::https://github.com/canonical/istio-operators//charms/istio-pilot/terraform?ref=track/1.22"
  model_name = var.model_name
  config = {
    default-gateway = var.istio_default_gateway,
  }
  revision = var.istio_pilot_revision
}

module "knative_operator" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-operator//terraform?ref=track/1.12"
  model_name = var.model_name
  revision   = var.knative_operator_revision
}

module "knative_serving" {
  source     = "git::https://github.com/canonical/knative-operators//charms/knative-serving//terraform?ref=track/1.12"
  model_name = var.model_name
  config = {
    "istio.gateway.namespace" = var.model_name,
    "istio.gateway.name"      = var.default_gateway,
    namespace                 = "knative-serving",
  }
  revision = var.knative_serving_revision
}

module "kserve_controller" {
  source     = "git::https://github.com/canonical/kserve-operators//charms/kserve-controller//terraform?ref=track/0.13"
  model_name = var.model_name
  config = {
    deployment-mode = "serverless",
  }
  revision = var.kserve_controller_revision
}
