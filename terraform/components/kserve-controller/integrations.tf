# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# ingress-gateway (istio-gateway-info): istio-pilot:gateway-info -> kserve-controller.
# Used by both knative and standard modes when fronted by istio sidecar.
resource "juju_integration" "kserve_controller_ingress_gateway" {
  count      = var.ingress_gateway != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kserve_controller.name
    endpoint = "ingress-gateway"
  }

  application {
    name      = var.ingress_gateway.kind == "endpoint" ? var.ingress_gateway.name : null
    endpoint  = var.ingress_gateway.kind == "endpoint" ? var.ingress_gateway.endpoint : null
    offer_url = var.ingress_gateway.kind == "offer" ? var.ingress_gateway.url : null
  }
}

# gateway-metadata: Envoy / ambient Istio ingress -> kserve-controller.
# Standard-mode alternative to ingress-gateway (do not set both).
resource "juju_integration" "kserve_controller_gateway_metadata" {
  count      = var.gateway_metadata != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kserve_controller.name
    endpoint = "gateway-metadata"
  }

  application {
    name      = var.gateway_metadata.kind == "endpoint" ? var.gateway_metadata.name : null
    endpoint  = var.gateway_metadata.kind == "endpoint" ? var.gateway_metadata.endpoint : null
    offer_url = var.gateway_metadata.kind == "offer" ? var.gateway_metadata.url : null
  }
}

# service-mesh: istio-beacon-k8s:service-mesh -> kserve-controller.
# Joins the controller to the ambient mesh (used with gateway-metadata).
resource "juju_integration" "kserve_controller_service_mesh" {
  count      = var.service_mesh != null ? 1 : 0
  model_uuid = var.model_uuid

  application {
    name     = juju_application.kserve_controller.name
    endpoint = "service-mesh"
  }

  application {
    name      = var.service_mesh.kind == "endpoint" ? var.service_mesh.name : null
    endpoint  = var.service_mesh.kind == "endpoint" ? var.service_mesh.endpoint : null
    offer_url = var.service_mesh.kind == "offer" ? var.service_mesh.url : null
  }
}
