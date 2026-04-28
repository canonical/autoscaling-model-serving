variable "risk" {
  type        = string
  description = "Risk for all charm channels"
  default     = "stable"

  validation {
    condition     = contains(["stable", "candidate", "beta", "edge"], var.risk)
    error_message = "Valid values for var: risk are (stable, candidate, beta and edge)."
  }
}

variable "create_model" {
  description = "Whether to create a model or reuse one created in a higher level module"
  type        = bool
  default     = true
}

variable "model" {
  description = "Model name"
  type        = string
  default     = "as-model-serving"
}

variable "cos_configuration" {
  description = "Boolean value that enables COS configuration"
  type        = bool
  default     = false
}

variable "existing_grafana_agent_name" {
  description = "Name of an existing grafana-agent-k8s deployment"
  type        = string
  default     = null
}

variable "grafana_agent_k8s_revision" {
  description = "Charm revision for grafana-agent-k8s"
  type        = number
  default     = null
}

variable "grafana_agent_k8s_size" {
  description = "Grafana agent database storage size"
  type        = string
  default     = "10G"
}

variable "istio_default_gateway" {
  description = "istio-pilot default-gateway configuration"
  type        = string
  default     = "istio-gateway"
}

variable "istio_ingressgateway_revision" {
  description = "Charm revision for istio-ingressgateway"
  type        = number
  default     = null
}

variable "istio_pilot_revision" {
  description = "Charm revision for istio-pilot"
  type        = number
  default     = null
}

variable "knative_operator_revision" {
  description = "Charm revision for knative-operator"
  type        = number
  default     = null
}

variable "knative_serving_revision" {
  description = "Charm revision for knative-serving"
  type        = number
  default     = null
}

variable "kserve_controller_revision" {
  description = "Charm revision for kserve-controller"
  type        = number
  default     = null
}

variable "kserve_mode" {
  description = "KServe's deployment mode"
  type        = string
  default     = "knative"

  validation {
    condition     = contains(["knative", "standard"], var.kserve_mode)
    error_message = "Valid values for var: kserve_mode are (knative, standard)."
  }
}
