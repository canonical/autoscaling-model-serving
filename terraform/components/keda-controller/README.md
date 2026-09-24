# KEDA controller component

Deploys the `keda-controller` charm, which packages KEDA (Kubernetes
Event-driven Autoscaling): the operator, external-metrics API server, admission
webhooks and the KEDA CRDs. It is a standalone component so it can be reused
independently of the KServe serving stack; workloads scale via ScaledObjects
against the cluster-wide CRDs.

## Inputs

| Name | Type | Description |
| --- | --- | --- |
| `model_uuid` | `string` | UUID of the Juju model to deploy into. |
| `keda_controller` | `object` | Configuration for `keda-controller`. |

## Outputs

- `components` — the deployed `keda-controller` `juju_application`.
- `provides` — `keda_controller_sync` (KEDA readiness) and `keda_controller_metrics_endpoint` (prometheus_scrape).
- `requires` — `keda_controller_logging` (Loki logging for COS).
