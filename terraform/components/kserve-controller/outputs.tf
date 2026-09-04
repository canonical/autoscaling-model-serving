# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed applications"
  value = {
    kserve_controller = juju_application.kserve_controller
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    kserve_controller_metrics_endpoint = {
      name     = juju_application.kserve_controller.name
      endpoint = "metrics-endpoint"
    }
    kserve_controller_sync = {
      name     = juju_application.kserve_controller.name
      endpoint = "kserve-controller"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    kserve_controller_ingress_gateway = {
      name     = juju_application.kserve_controller.name
      endpoint = "ingress-gateway"
    }
    kserve_controller_gateway_metadata = {
      name     = juju_application.kserve_controller.name
      endpoint = "gateway-metadata"
    }
    kserve_controller_service_mesh = {
      name     = juju_application.kserve_controller.name
      endpoint = "service-mesh"
    }
    kserve_controller_logging = {
      name     = juju_application.kserve_controller.name
      endpoint = "logging"
    }
  }
}
