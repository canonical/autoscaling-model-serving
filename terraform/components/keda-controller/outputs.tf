# Copyright 2026 Canonical Ltd.
# See LICENSE file for licensing details.

output "components" {
  description = "Map of the deployed applications"
  value = {
    keda_controller = juju_application.keda_controller
  }
}

output "provides" {
  description = "Map of endpoints provided by this component to other components (outbound relations)"
  value = {
    # KEDA readiness, consumed by charms that create ScaledObjects.
    keda_controller_sync = {
      name     = juju_application.keda_controller.name
      endpoint = "keda"
    }
    # prometheus_scrape metrics, consumed by an observability collector.
    keda_controller_metrics_endpoint = {
      name     = juju_application.keda_controller.name
      endpoint = "metrics-endpoint"
    }
  }
}

output "requires" {
  description = "Map of endpoints required by this component from other components (inbound relations)"
  value = {
    keda_controller_logging = {
      name     = juju_application.keda_controller.name
      endpoint = "logging"
    }
  }
}
