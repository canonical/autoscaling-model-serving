# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of the Juju model where keda-controller is deployed"
  type        = string
  nullable    = false
}

variable "keda_controller" {
  description = "Configuration for the keda-controller application"
  type = object({
    app_name    = optional(string, "keda-controller")
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
