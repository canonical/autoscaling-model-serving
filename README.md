# Autoscaling model server bundle

The autoscaling model server bundle is comprised of:

* `istio-operators`
* `knative-operators`
* `kserve-controller`

And offers the ability to deploy a model server in any Kubernetes cluster for it to be reached out by users outside of it.

## Install

### Using the Terraform solution

This repository contains a Terraform solution for the `autoscaling-model-server`, for more information on usage, please refer to the [solution README.md](https://github.com/canonical/autoscaling-model-server/tree/track/0.1/terraform).

### Charm bundle

The `autoscaling-model-server` is a charm bundle that can be installed with:

```
juju deploy ./bundle/bundle.yaml --trust
```

### Required configuration

After the bundle is deployed, the following configuration is required:

```
# Namespace of the Istio ingress gateway
# This value is the model name where the autoscaling-model-server bundle was deployed
juju config knative-serving istio.gateway.namespace="<namespace of the Istio ingress gateway>"
```
