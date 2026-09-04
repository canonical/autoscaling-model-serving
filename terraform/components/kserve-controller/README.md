# KServe controller component

Deploys a standalone `kserve-controller` in **standard (RawDeployment)** mode —
no Knative. It is used by the `kserve` product's standard mode, fronted by the
istio-sidecar gateway via the `ingress-gateway` relation.

`kserve-controller` in standard mode accepts its ingress from **either**:

- `ingress_gateway` — the `istio-gateway-info` interface (e.g.
  `istio-pilot:gateway-info`), or
- `gateway_metadata` — the `gateway_metadata` interface (e.g. an Envoy or
  ambient Istio ingress).

These are **mutually exclusive**: the charm blocks if both relations are
established, so set only one. For external ingress in RawDeployment mode use
`gateway_metadata` (Gateway API / HTTPRoute); the `ingress_gateway` (sidecar)
path only creates a Kubernetes `Ingress`, which the istio-sidecar gateway does
not serve. In ambient mode also wire `service_mesh` (istio-beacon-k8s) so the
controller joins the mesh.

## Inputs

| Name | Type | Description |
| --- | --- | --- |
| `model_uuid` | `string` | UUID of the Juju model to deploy into. |
| `kserve_controller` | `object` | Configuration for `kserve-controller` (defaults to `deployment-mode=standard`). |
| `ingress_gateway` | `object({kind,name,endpoint,url})` | Istio sidecar gateway endpoint (`null` to skip). |
| `gateway_metadata` | `object({kind,name,endpoint,url})` | Envoy / ambient gateway endpoint (`null` to skip). |
| `service_mesh` | `object({kind,name,endpoint,url})` | Ambient mesh endpoint from istio-beacon-k8s (`null` to skip). |

## Outputs

- `components` — the deployed `kserve-controller` `juju_application`.
- `provides` — `metrics-endpoint`, `kserve-controller` (sync).
- `requires` — `ingress-gateway`, `gateway-metadata`, `service-mesh`, `logging`.
