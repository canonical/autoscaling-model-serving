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

ISTIO_GATEWAY_SERVICE_NAME = "istio-ingressgateway-workload"
ISVC = lightkube.generic_resource.create_namespaced_resource(
    group="serving.kserve.io",
    version="v1beta1",
    kind="InferenceService",
    plural="inferenceservices",
    verbs=None,
)
SKLEARN_ISVC_YAML = yaml.safe_load(Path("./tests/integration/sklearn-iris.yaml").read_text())
SKLEARN_ISVC_OBJECT = lightkube.codecs.load_all_yaml(yaml.dump(SKLEARN_ISVC_YAML))[0]  # noqa
SKLEARN_ISVC_NAME = SKLEARN_ISVC_OBJECT.metadata.name
STANDARD_MODE_NAME = "standard"

logger = logging.getLogger(__name__)


@pytest.fixture(scope="session")
def lightkube_client() -> lightkube.Client:
    client = lightkube.Client(field_manager="autoscaling-bundle")
    return client


@pytest.mark.dependency()
async def test_terraform_solution_deployment(tf_vars):
    """Deploy the whole Terraform solution."""
    chdir("terraform")
    subprocess.run(["terraform", "init"], check=True)
    subprocess.run(
        [
            "terraform",
            "apply",
            "-auto-approve",
        ]
        + tf_vars,
        check=True,
    )


@pytest.mark.dependency(depends=["test_terraform_solution_deployment"])
async def test_kserve_mode(ops_test: OpsTest, kserve_mode: str):
    """Check that the mode of KServe is as expected."""
    kserve_controller_application = ops_test.model.applications["kserve-controller"]
    actual_kserve_controller_configs = await kserve_controller_application.get_config()
    actual_kserve_mode = actual_kserve_controller_configs["deployment-mode"]["value"]
    assert actual_kserve_mode == kserve_mode


@pytest.mark.dependency(depends=["test_terraform_solution_deployment"])
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


@pytest.mark.dependency(depends=["test_charms_active"])
def test_inference_service_deployment(ops_test: OpsTest, lightkube_client: lightkube.Client):
    """Create an InferenceService and validate it has a status."""
    # Use the model namespace for deploying the ISVC
    isvc_namespace = ops_test.model.name

    # Create InferenceService from example file
    @tenacity.retry(
        wait=tenacity.wait_exponential(multiplier=1, min=1, max=15),
        stop=tenacity.stop_after_delay(30),
        reraise=True,
    )
    def create_inf_svc():
        lightkube_client.create(SKLEARN_ISVC_OBJECT, namespace=isvc_namespace)

    # Assert InferenceService state is Available
    @tenacity.retry(
        wait=tenacity.wait_exponential(multiplier=1, min=1, max=15),
        stop=tenacity.stop_after_attempt(30),
        reraise=True,
    )
    def assert_isvc_state():
        inf_svc = lightkube_client.get(ISVC, SKLEARN_ISVC_NAME, namespace=isvc_namespace)
        conditions = inf_svc.get("status", {}).get("conditions")
        status_overall = False
        for condition in conditions:
            if (
                condition.get("status") in ["False", "Unknown"]
                and condition.get("type") != "Stopped"
            ):
                status_overall = False
                break
            status_overall = True
        assert status_overall

    create_inf_svc()
    assert_isvc_state()


@pytest.mark.dependency(depends=["test_inference_service_deployment"])
def test_inference_request(ops_test: OpsTest, lightkube_client: lightkube.Client, kseve_mode: str):
    """Perform a POST request with data for sklearn-iris ISVC."""
    namespace = ops_test.model.name

    gateway_ip_address = lightkube_client.get(
        lightkube.resources.core_v1.Service,
        name=ISTIO_GATEWAY_SERVICE_NAME,
        namespace=namespace,
    ).status.loadBalancer.ingress[0].ip
    isvc_url = get_isvc_url(
        isvc_name=SKLEARN_ISVC_NAME,
        isvc_namespace=namespace,
        lightkube_client=lightkube_client,
    )
    headers = {"Content-Type": "application/json"}
    if kseve_mode == STANDARD_MODE_NAME:
        headers["Host"] = isvc_url.replace("http://", "")
    base_url = f"http://{gateway_ip_address}" if STANDARD_MODE_NAME else isvc_url
    endpoint_url = f"{base_url}/v1/models/{SKLEARN_ISVC_NAME}:predict"
    # input data from the example https://kserve.github.io/website/latest/get_started/first_isvc/
    prediction_input = json.dumps({"instances": [[6.8, 2.8, 4.8, 1.4], [6.0, 3.4, 4.5, 1.6]]})

    inference_response = requests.post(endpoint_url, headers=headers, data=prediction_input).text

    assert inference_response == '{"predictions":[1,1]}'


@tenacity.retry(
    wait=tenacity.wait_exponential(multiplier=1, min=1, max=15),
    stop=tenacity.stop_after_attempt(30),
    reraise=True,
)
def get_isvc_url(isvc_name: str, isvc_namespace: str, lightkube_client: lightkube.Client) -> str:
    """Return the ISVC url from an existing ISVC in the K8s deployment."""
    isvc_object = lightkube_client.get(ISVC, isvc_name, namespace=isvc_namespace)
    return isvc_object.get("status")["url"]
