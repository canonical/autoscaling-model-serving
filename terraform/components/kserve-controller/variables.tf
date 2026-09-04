# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where kserve-controller is deployed"
  type        = string
  nullable    = false
}

variable "kserve_controller" {
  description = "Configuration for the kserve-controller application. Defaults to standard (RawDeployment) mode."
  type = object({
    app_name    = optional(string, "kserve-controller")
    channel     = optional(string, "latest/edge")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), { "deployment-mode" = "standard" })
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "ingress_gateway" {
  description = <<-EOT
    Ingress gateway endpoint consumed by kserve-controller (istio-gateway-info
    interface, e.g. from istio-pilot:gateway-info). Supports a same-model
    endpoint or a cross-model offer. Mutually exclusive with gateway_metadata:
    the charm blocks if both relations are established.
  EOT
  type = object({
    kind     = string
    name     = optional(string)
    endpoint = optional(string)
    url      = optional(string)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.ingress_gateway == null ? true : contains(["endpoint", "offer"], var.ingress_gateway.kind)
    error_message = "ingress_gateway.kind must be either \"endpoint\" or \"offer\"."
  }
}

variable "gateway_metadata" {
  description = <<-EOT
    Gateway metadata endpoint consumed by kserve-controller (gateway_metadata
    interface, e.g. from an Envoy or ambient Istio ingress). Supports a
    same-model endpoint or a cross-model offer. Mutually exclusive with
    ingress_gateway: the charm blocks if both relations are established.
  EOT
  type = object({
    kind     = string
    name     = optional(string)
    endpoint = optional(string)
    url      = optional(string)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.gateway_metadata == null ? true : contains(["endpoint", "offer"], var.gateway_metadata.kind)
    error_message = "gateway_metadata.kind must be either \"endpoint\" or \"offer\"."
  }
}

variable "service_mesh" {
  description = <<-EOT
    Service-mesh endpoint consumed by kserve-controller (service_mesh interface,
    e.g. from istio-beacon-k8s:service-mesh) so the controller joins the ambient
    mesh. Supports a same-model endpoint or a cross-model offer. Used together
    with gateway_metadata in ambient/standard mode.
  EOT
  type = object({
    kind     = string
    name     = optional(string)
    endpoint = optional(string)
    url      = optional(string)
  })
  nullable = true
  default  = null

  validation {
    condition     = var.service_mesh == null ? true : contains(["endpoint", "offer"], var.service_mesh.kind)
    error_message = "service_mesh.kind must be either \"endpoint\" or \"offer\"."
  }
}
