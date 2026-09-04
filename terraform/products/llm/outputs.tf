# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "model_uuid" {
  description = "UUID of the Juju model the LLM serving stack is deployed into"
  value       = local.model_uuid
}

output "envoy" {
  description = "Outputs of the Envoy Gateway component (components, provides, requires)"
  value = {
    components = module.envoy.components
    provides   = module.envoy.provides
    requires   = module.envoy.requires
  }
}

output "kserve_llm" {
  description = "Outputs of the KServe LLM serving component (components, provides, requires)"
  value = {
    components = module.kserve_llm.components
    provides   = module.kserve_llm.provides
    requires   = module.kserve_llm.requires
  }
}

output "observability" {
  description = "Outputs of the observability component (components, provides). Null when observability is disabled."
  value = var.enable_observability ? {
    components = module.observability[0].components
    provides   = module.observability[0].provides
  } : null
}
