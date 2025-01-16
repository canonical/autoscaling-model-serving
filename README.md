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

# Configure knative-serving with Istio information
# Name of the Istio ingress gateway
juju config knative-serving istio.gateway.name="<name of the Istio ingress gateway>"
juju config istio-pilot default-gateway

# Namespace of the Istio ingress gateway
# This value is the model name where the autoscaling-model-server bundle was deployed
juju config knative-serving istio.gateway.namespace="<namespace of the Istio ingress gateway>"
```
