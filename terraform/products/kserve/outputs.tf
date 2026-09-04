# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "model_uuid" {
  description = "UUID of the Juju model the KServe serving stack is deployed into"
  value       = local.model_uuid
}

output "istio" {
  description = "Outputs of the active Istio component (components, provides, requires). In serverless mode this is the istio-sidecar component; in standard mode it is the istio-ambient component."
  value = local.serverless ? {
    components = module.istio[0].components
    provides   = module.istio[0].provides
    requires   = module.istio[0].requires
    } : {
    components = module.istio_ambient[0].components
    provides   = module.istio_ambient[0].provides
    requires   = module.istio_ambient[0].requires
  }
}

output "kserve" {
  description = "Outputs of the active KServe component (components, provides, requires). In serverless mode this is the Knative-backed kserve component; in standard mode it is the standalone kserve-controller."
  value = local.serverless ? {
    components = module.kserve[0].components
    provides   = module.kserve[0].provides
    requires   = module.kserve[0].requires
    } : {
    components = module.kserve_controller[0].components
    provides   = module.kserve_controller[0].provides
    requires   = module.kserve_controller[0].requires
  }
}
