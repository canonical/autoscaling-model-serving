# Autoscaling model server Terraform solution


This is a Terraform module facilitating the deployment of the Autoscaling model server solution, using the [Terraform juju provider](https://github.com/juju/terraform-provider-juju/). For more information, refer to the provider [documentation](https://registry.terraform.io/providers/juju/juju/latest/docs). 

## API

### Inputs
The solution module offers the following configurable inputs:

| Name | Type | Description | Required |
| - | - | - | - |
| `<charm_name>_revision`| number | For each charm of the solution, the revision of the charm to deploy | False |
| `cos_configuration`| bool | Boolean value that enables COS configuration | False |
| `create_model`| bool | Whether to create a model or reuse one created in a higher level module | False |
| `existing_grafana_agent_name`| string | Name of an existing grafana-agent-k8s deployment | False |
| `istio_default_gateway`| string | Name of the Istio default ingress gateway | False |
| `model`| string | Name of the Juju model for deployment | False |

### Outputs
Upon applied, the solution module exports the following outputs:

| Name | Description |
| - | - |
| `grafana_agent_k8s`| Map containing the `app_name`, `provides` and `requires` endpoints of the grafana-agent-k8s charm used |

## Usage

This solution module is intended to be used either on its own or as part of a higher-level module. 

### COS configuration

#### Enable COS configuration
The `cos_configuration` input enables the solution to configure the solution's components to integrate with COS. This is done by deploying a `grafana-agent-k8s` charm and adding all the required relations.
```
terraform apply -var cos_configuration=true
```

#### Use an existing grafana-agent-k8s
If there is already an instance of the grafana-agent-k8s charm in the deployed model, then it can be used instead of deploying a new one. This is achieved with the use of `existing_grafana_agent_name` input. By default, its value is `null`.
```
terraform apply -var cos_configuration=true -var existing_grafana_agent_name="dummy-grafana-agent"
```
> :warning: Setting this input without `cos_configuration` will not have any effect.
