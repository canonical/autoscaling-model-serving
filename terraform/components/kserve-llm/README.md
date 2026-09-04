# KServe LLM serving component

This component deploys the KServe control plane for **LLM inference serving**:
`kserve-controller` (in `standard` deployment mode), the `kserve-llmisvc`
controller that reconciles `LLMInferenceService` resources, and the
`lws-controller` (LeaderWorkerSet) used for multi-node inference worker groups.

The applications are declared inline (rather than sourcing the per-charm
Terraform modules) so that the whole component is `model_uuid`-based and
consistent with the rest of the solution.

> **Note:** `llm-integrator` is intentionally excluded. It is deployed by the
> end user on top of this stack and related to `kserve-llmisvc` via the
> `kserve_llmisvc_sync` provided endpoint.

## Applications

| Application | Charm | Role |
| --- | --- | --- |
| `kserve-controller` | `kserve-controller` | KServe control plane (standard mode). |
| `kserve-llmisvc` | `kserve-llmisvc` | Reconciles `LLMInferenceService` resources. |
| `lws-controller` | `lws-controller` | LeaderWorkerSet controller for multi-node workers. |

## Intra-component integrations

- `kserve-controller:kserve-controller` ↔ `kserve-llmisvc:kserve-controller`
- `lws-controller:lws-controller` ↔ `kserve-llmisvc:lws-controller`

## Inputs

| Name | Type | Description |
| --- | --- | --- |
| `model_uuid` | `string` | UUID of the Juju model to deploy into. |
| `kserve_controller` | `object` | Configuration for `kserve-controller`. |
| `kserve_llmisvc` | `object` | Configuration for `kserve-llmisvc`. |
| `lws_controller` | `object` | Configuration for `lws-controller`. |
| `gateway_metadata` | `object` | Gateway metadata endpoint (`{kind, name, endpoint, url}`) consumed by `kserve-controller`. `null` to skip. |

## Outputs

- `components` — map of the deployed `juju_application` resources.
- `provides` — outbound endpoints (`kserve_llmisvc_sync`, metrics and dashboard endpoints).
- `requires` — inbound endpoints (`gateway-metadata`, `logging`).
