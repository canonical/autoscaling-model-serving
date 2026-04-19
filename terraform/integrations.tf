resource "juju_integration" "istio_pilot_istio_ingressgateway_istio_pilot" {
  model = var.create_model ? juju_model.as_model_server[0].name : var.model

  application {
    name     = module.istio_pilot.app_name
    endpoint = module.istio_pilot.provides.istio_pilot
  }

  application {
    name     = module.istio_ingressgateway.app_name
    endpoint = module.istio_ingressgateway.requires.istio_pilot
  }
}

resource "juju_integration" "istio_pilot_kserve_controller_gateway_info" {
  model = var.create_model ? juju_model.as_model_server[0].name : var.model

  application {
    name     = module.istio_pilot.app_name
    endpoint = module.istio_pilot.provides.gateway_info
  }

  application {
    name     = module.kserve_controller.app_name
    endpoint = module.kserve_controller.requires.ingress_gateway
  }
}

resource "juju_integration" "kserve_controller_knative_serving_local_gateway" {
  model = var.create_model ? juju_model.as_model_server[0].name : var.model

  application {
    name     = module.kserve_controller.app_name
    endpoint = module.kserve_controller.requires.local_gateway
  }

  application {
    name     = module.knative_serving.app_name
    endpoint = module.knative_serving.provides.local_gateway
  }
}

resource "juju_integration" "istio_pilot_kserve_controller_gateway_info" {
  model = var.create_model ? juju_model.as_model_server[0].name : var.model

  application {
    name     = module.istio_pilot.app_name
    endpoint = module.istio_pilot.provides.gateway_info
  }

  application {
    name     = module.kserve_controller.app_name
    endpoint = module.kserve_controller.requires.ingress_gateway
  }
}
