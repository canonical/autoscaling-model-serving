# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

variable "model_uuid" {
  description = "UUID of an existing Juju model to deploy the LLM serving stack into. When null, a new model named var.model_name is created."
  type        = string
  nullable    = true
  default     = null
}

variable "model_name" {
  description = "Name of the Juju model to create for the LLM serving stack when model_uuid is not provided"
  type        = string
  default     = "kserve-llm"
}

variable "cloud" {
  description = "Kubernetes cloud to create the LLM model on when model_uuid is not provided. Null uses Juju's default cloud."
  type        = string
  nullable    = true
  default     = null
}

variable "create_cos_model" {
  description = "Create a Juju model for the COS deployment"
  type        = bool
  default     = true
}

variable "cos_model_uuid" {
  description = "UUID of an existing Juju model to deploy COS into (required when create_cos_model is false)"
  type        = string
  nullable    = true
  default     = null

  validation {
    condition     = var.create_cos_model || var.cos_model_uuid != null
    error_message = "cos_model_uuid must be provided when create_cos_model is false."
  }
}

variable "cos_model_name" {
  description = "Name of the Juju model to create for COS"
  type        = string
  default     = "cos"
}

variable "cos_channel" {
  description = "Channel to deploy COS Lite applications from"
  type        = string
  default     = "2/stable"
}
