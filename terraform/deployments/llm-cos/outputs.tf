# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "model_uuid" {
  description = "UUID of the Juju model the LLM serving stack is deployed into (created when model_uuid was not provided, otherwise the supplied one)."
  value       = module.llm.model_uuid
}
