variable "cos_configuration" {
  description = "Boolean value that enables COS configuration"
  type        = bool
  default     = false
}

variable "create_model" {
  description = "Whether to create a model or re-use one created in a higher level module"
  type        = bool
  default     = true
}

variable "default_gateway" {
  description = "Name of the Istio default ingress gateway"
  type        = string
  default     = "as-model-server"
}

variable "existing_grafana_agent_name" {
  description = "Name of an existing grafana-agent-k8s deployment"
  type        = string
  default     = null
}

variable "grafana_agent_k8s_disk_size" {
  description = "Grafana agent root-disk size for database storage"
  type        = string
  default     = "root-disk=10G"
}

variable "grafana_agent_k8s_revision" {
  description = "Charm revision for grafana-agent-k8s"
  type        = number
  default     = null
}

variable "istio_default_gateway" {
  description = "istio-pilot default-gateway configuration"
  type        = string
  default     = null
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
