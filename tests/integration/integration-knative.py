# Copyright 2025 Canonical Ltd.
# See LICENSE file for licensing details.

import json
import logging
import subprocess
from os import chdir
from pathlib import Path

import lightkube
import lightkube.codecs
import pytest
import requests
import tenacity
import yaml
from pytest_operator.plugin import OpsTest

ISVC = lightkube.generic_resource.create_namespaced_resource(
    group="serving.kserve.io",
    version="v1beta1",
    kind="InferenceService",
    plural="inferenceservices",
    verbs=None,
)
# Use the default istio-gateway name
ISTIO_GATEWAY_NAME = "istio-gateway"
SKLEARN_ISVC_YAML = yaml.safe_load(Path("./tests/integration/sklearn-iris.yaml").read_text())
SKLEARN_ISVC_OBJECT = lightkube.codecs.load_all_yaml(yaml.dump(SKLEARN_ISVC_YAML))[0]  # noqa
SKLEARN_ISVC_NAME = SKLEARN_ISVC_OBJECT.metadata.name

logger = logging.getLogger(__name__)


@pytest.fixture(scope="session")
def lightkube_client() -> lightkube.Client:
    client = lightkube.Client(field_manager="autoscaling-bundle")
    return client


@pytest.mark.abort_on_fail
async def test_terraform_solution_deployment():
    """Deploy the whole Terraform solution."""
    chdir("terraform")
    subprocess.run(["terraform", "init"], check=True)
    subprocess.run(["terraform", "apply", "-auto-approve"], check=True)


@pytest.mark.abort_on_fail
async def test_charms_active(ops_test: OpsTest):
    """Wait for all charmed applications to be active."""
    apps = list(ops_test.model.applications.keys())
    await ops_test.model.wait_for_idle(
        apps=apps,
        status="active",
        raise_on_blocked=False,
        raise_on_error=False,
        timeout=3600,
    )


#     await ops_test.model.applications["knative-serving"].set_config(
#         {
#             "istio.gateway.name": ISTIO_GATEWAY_NAME,
#             "istio.gateway.namespace": ops_test.model.name,
#         }
#     )
#     await ops_test.model.wait_for_idle(status="active", timeout=90 * 10, raise_on_error=False)


@pytest.mark.abort_on_fail
def test_inference_service_deployment(ops_test: OpsTest, lightkube_client: lightkube.Client):
    """Create an InferenceService and validate it has a status."""
    # Use the model namespace for deploying the ISVC
    serverless_namespace = ops_test.model.name

    # Create InferenceService from example file
    @tenacity.retry(
        wait=tenacity.wait_exponential(multiplier=1, min=1, max=15),
        stop=tenacity.stop_after_delay(30),
        reraise=True,
    )
    def create_inf_svc():
        lightkube_client.create(SKLEARN_ISVC_OBJECT, namespace=serverless_namespace)

    # Assert InferenceService state is Available
    @tenacity.retry(
        wait=tenacity.wait_exponential(multiplier=1, min=1, max=15),
        stop=tenacity.stop_after_attempt(30),
        reraise=True,
    )
    def assert_isvc_state():
        status_overall = False
        inf_svc = lightkube_client.get(ISVC, SKLEARN_ISVC_NAME, namespace=serverless_namespace)
        conditions = inf_svc.get("status", {}).get("conditions")
        for condition in conditions:
            if condition.get("status") == "False":
                status_overall = False
                break
            status_overall = True
        assert status_overall is True

    create_inf_svc()
    assert_isvc_state()


@pytest.mark.abort_on_fail
def test_inference_request(ops_test: OpsTest, lightkube_client: lightkube.Client):
    """Perform a POST request with data for sklearn-iris ISVC."""
    # This input data is hardcoded based on
    # the example in https://kserve.github.io/website/latest/get_started/first_isvc/
    sklearn_iris_input = {"instances": [[6.8, 2.8, 4.8, 1.4], [6.0, 3.4, 4.5, 1.6]]}
    headers = {"Content-Type": "application/json"}
    url = get_isvc_url(
        isvc_name=SKLEARN_ISVC_NAME,
        isvc_namespace=ops_test.model.name,
        lightkube_client=lightkube_client,
    )
    inference_response = requests.post(
        f"{url}/v1/models/{SKLEARN_ISVC_NAME}:predict",
        headers=headers,
        data=json.dumps(sklearn_iris_input),
    ).text
    assert inference_response == '{"predictions":[1,1]}'


@tenacity.retry(
    wait=tenacity.wait_exponential(multiplier=1, min=1, max=15),
    stop=tenacity.stop_after_attempt(30),
    reraise=True,
)
def get_isvc_url(isvc_name: str, isvc_namespace: str, lightkube_client: lightkube.Client) -> str:
    """Return the ISVC url from an existing ISVC in the K8s deployment."""
    isvc_object = lightkube_client.get(ISVC, isvc_name, namespace=isvc_namespace)
    return isvc_object.get("status")["components"]["predictor"]["url"]
