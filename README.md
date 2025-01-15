# Autoscaling model server bundle

The autoscaling model server bundle is comprised of:

* `istio-operators`
* `knative-operators`
* `kserve-controller`

And offers the ability to deploy a model server in any Kubernetes cluster for it to be reached out by users outside of it.

## Install

### Charm bundle

The `autoscaling-model-server` is a charm bundle that can be installed with:

```
juju deploy autoscaling-model-server --trust
```
