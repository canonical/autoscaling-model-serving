# TODO: Update to use a reusable module instead of defining
# a `juju_application` resource
resource "juju_application" "grafana_agent_k8s" {
  count = var.cos_configuration && var.existing_grafana_agent_name == null ? 1 : 0
  charm {
    name     = "grafana-agent-k8s"
    channel  = "latest/stable"
    revision = var.grafana_agent_k8s_revision
  }
  model = var.model_name
  name  = "grafana-agent-k8s-kubeflow"
  storage_directives = {
    data = var.grafana_agent_k8s_size
  }
  trust = true
  units = 1
}

resource "juju_integration" "istio_ingressgateway_grafana_agent_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.model_name

  application {
    name     = module.istio_ingressgateway.app_name
    endpoint = module.istio_ingressgateway.provides.metrics_endpoint
  }

  application {
    name     = var.existing_grafana_agent_name == null ? juju_application.grafana_agent_k8s[count.index].name : var.existing_grafana_agent_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "istio_pilot_grafana_agent_k8s_grafana_dashboard" {
  count = var.cos_configuration ? 1 : 0
  model = var.model_name

  application {
    name     = module.istio_pilot.app_name
    endpoint = module.istio_pilot.provides.grafana_dashboard
  }

  application {
    name     = var.existing_grafana_agent_name == null ? juju_application.grafana_agent_k8s[count.index].name : var.existing_grafana_agent_name
    endpoint = "grafana-dashboards-consumer"
  }
}

resource "juju_integration" "istio_pilot_grafana_agent_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.model_name

  application {
    name     = module.istio_pilot.app_name
    endpoint = module.istio_pilot.provides.metrics_endpoint
  }

  application {
    name     = var.existing_grafana_agent_name == null ? juju_application.grafana_agent_k8s[count.index].name : var.existing_grafana_agent_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "knative_serving_knative_operator_otel_collector" {
  count = var.cos_configuration ? 1 : 0
  model = var.model_name

  application {
    name     = module.knative_serving.app_name
    endpoint = module.knative_serving.requires.otel_collector
  }

  application {
    name     = module.knative_operator.app_name
    endpoint = module.knative_operator.provides.otel_collector
  }
}

resource "juju_integration" "knative_operator_grafana_agent_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.model_name

  application {
    name     = module.knative_operator.app_name
    endpoint = module.knative_operator.provides.metrics_endpoint
  }

  application {
    name     = var.existing_grafana_agent_name == null ? juju_application.grafana_agent_k8s[count.index].name : var.existing_grafana_agent_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "knative_operator_grafana_agent_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.model_name

  application {
    name     = module.knative_operator.app_name
    endpoint = module.knative_operator.requires.logging
  }

  application {
    name     = var.existing_grafana_agent_name == null ? juju_application.grafana_agent_k8s[count.index].name : var.existing_grafana_agent_name
    endpoint = "logging-provider"
  }
}

resource "juju_integration" "kserve_controller_grafana_agent_k8s_metrics_endpoint" {
  count = var.cos_configuration ? 1 : 0
  model = var.model_name

  application {
    name     = module.kserve_controller.app_name
    endpoint = module.kserve_controller.provides.metrics_endpoint
  }

  application {
    name     = var.existing_grafana_agent_name == null ? juju_application.grafana_agent_k8s[count.index].name : var.existing_grafana_agent_name
    endpoint = "metrics-endpoint"
  }
}

resource "juju_integration" "kserve_controller_grafana_agent_k8s_grafana_logging" {
  count = var.cos_configuration ? 1 : 0
  model = var.model_name

  application {
    name     = module.kserve_controller.app_name
    endpoint = module.kserve_controller.requires.logging
  }

  application {
    name     = var.existing_grafana_agent_name == null ? juju_application.grafana_agent_k8s[count.index].name : var.existing_grafana_agent_name
    endpoint = "logging-provider"
  }
}
