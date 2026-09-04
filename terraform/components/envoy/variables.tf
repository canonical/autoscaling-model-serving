# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where the Envoy Gateway stack is deployed"
  type        = string
  nullable    = false
}

variable "envoy_controller_k8s" {
  description = "Configuration for the envoy-controller-k8s application (Envoy Gateway control plane)"
  type = object({
    app_name    = optional(string, "envoy-controller-k8s")
    channel     = optional(string, "latest/edge")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "envoy_ai_controller_k8s" {
  description = "Configuration for the envoy-ai-controller-k8s application (Envoy AI Gateway control plane)"
  type = object({
    app_name    = optional(string, "envoy-ai-controller-k8s")
    channel     = optional(string, "latest/edge")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "envoy_ingress_k8s" {
  description = "Configuration for the envoy-ingress-k8s application (user-facing Gateway API resources)"
  type = object({
    app_name    = optional(string, "envoy-ingress-k8s")
    channel     = optional(string, "latest/edge")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, true)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}

variable "self_signed_certificates" {
  description = "Configuration for the self-signed-certificates application (issues TLS certs to the Envoy stack)"
  type = object({
    app_name    = optional(string, "self-signed-certificates")
    channel     = optional(string, "latest/stable")
    revision    = optional(number)
    units       = optional(number, 1)
    trust       = optional(bool, false)
    constraints = optional(string, "arch=amd64")
    config      = optional(map(string), {})
    resources   = optional(map(string), {})
  })
  default = {}
}
