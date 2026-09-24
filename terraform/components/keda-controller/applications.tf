# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

# KEDA (Kubernetes Event-driven Autoscaling) controller. Installs the KEDA CRDs
# cluster-wide so serving workloads can be scaled via ScaledObjects.
resource "juju_application" "keda_controller" {
  charm {
    name     = "keda-controller"
    channel  = var.keda_controller.channel
    revision = var.keda_controller.revision
  }

  model_uuid  = var.model_uuid
  name        = var.keda_controller.app_name
  units       = var.keda_controller.units
  trust       = var.keda_controller.trust
  constraints = var.keda_controller.constraints
  config      = var.keda_controller.config
  resources   = var.keda_controller.resources
}
