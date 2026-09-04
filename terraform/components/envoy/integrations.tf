# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# Extension Server: envoy-controller delegates AI-specific xDS fine-tuning to
# envoy-ai-controller. This relation is the AI Gateway on/off switch.
resource "juju_integration" "envoy_controller_extension_server" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.envoy_controller_k8s.name
    endpoint = "envoy-extension-server"
  }

  application {
    name     = juju_application.envoy_ai_controller_k8s.name
    endpoint = "envoy-extension-server"
  }
}

# TLS serving cert for the ExtProc admission webhook. This relation is
# mandatory: envoy-ai-controller blocks until certificates are established.
resource "juju_integration" "envoy_ai_controller_certificates" {
  model_uuid = var.model_uuid

  application {
    name     = juju_application.envoy_ai_controller_k8s.name
    endpoint = "certificates"
  }

  application {
    name     = juju_application.self_signed_certificates.name
    endpoint = "certificates"
  }
}
