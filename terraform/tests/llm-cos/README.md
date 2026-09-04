# llm-cos test scenario

Terraform root module used by the integration test suite for the **`llm-cos`**
scenario. It deploys COS Lite in its own model and the LLM serving
[`llm` product](../../products/llm) with observability enabled, wired to COS via
cross-model offers. Mirrors the `kubeflow-cos` scenario in Charmed Kubeflow
Solutions.

The LLM serving stack is deployed into a **pre-created** model (referenced by
`model_uuid`); the `cos` model is created by this module.

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `model_uuid` | `string` | — | UUID of the pre-created model for the LLM stack. |
| `create_cos_model` | `bool` | `true` | Create the `cos` model. |
| `cos_model_uuid` | `string` | `null` | Existing COS model UUID (when `create_cos_model = false`). |
| `cos_model_name` | `string` | `"cos"` | Name of the COS model to create. |
| `cos_channel` | `string` | `"2/stable"` | Channel for the COS Lite charms. |
