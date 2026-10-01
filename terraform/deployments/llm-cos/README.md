# llm-cos deployment

Deployment root module (CC008 Deployment tier) that stands up the LLM serving
stack together with COS Lite. It deploys COS Lite in its own model and the LLM
serving [`llm` product](../../products/llm) with observability enabled, wired to
COS via cross-model offers. Mirrors the `kubeflow-cos` scenario in Charmed
Kubeflow Solutions, and is used by the integration suite's `llm-cos` scenario.

The LLM serving stack is deployed into the model referenced by `model_uuid`.
When `model_uuid` is omitted, this module creates a new model named
`model_name` for the stack. The `cos` model is always created by this module
(unless an existing one is supplied via `cos_model_uuid`).

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `model_uuid` | `string` | `null` | UUID of an existing model for the LLM stack. When `null`, a model named `model_name` is created. |
| `model_name` | `string` | `"kserve-llm"` | Name of the LLM model to create when `model_uuid` is not provided. |
| `cloud` | `string` | `null` | Cloud to create the LLM model on when `model_uuid` is not provided. `null` uses Juju's default cloud. |
| `create_cos_model` | `bool` | `true` | Create the `cos` model. |
| `cos_model_uuid` | `string` | `null` | Existing COS model UUID (when `create_cos_model = false`). |
| `cos_model_name` | `string` | `"cos"` | Name of the COS model to create. |
| `cos_channel` | `string` | `"2/stable"` | Channel for the COS Lite charms. |

## Outputs

| Name | Description |
| --- | --- |
| `model_uuid` | UUID of the model the LLM serving stack is deployed into (created or supplied). |
