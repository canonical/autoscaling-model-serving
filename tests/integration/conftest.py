import pytest


def pytest_addoption(parser):
    """Add CLI options to pytest."""
    parser.addoption(
        "--risk",
        nargs="?",
        choices=["stable", "candidate", "beta", "edge"],
        const="edge",
        default="edge",
        type=str,
        help="Risk for charm channels",
    )
    parser.addoption(
        "--kserve-mode",
        nargs="?",
        choices=["knative", "standard"],
        const="knative",
        default="knative",
        type=str,
        help="KServe's deployment mode",
    )


@pytest.fixture(scope="module")
def risk(request) -> list[str]:
    """Risk for charm channels."""
    return request.config.getoption("--risk")


@pytest.fixture(scope="module")
def kserve_mode(request) -> list[str]:
    """KServe mode."""
    return request.config.getoption("--kserve-mode")


@pytest.fixture(scope="module")
def tf_vars(risk, kserve_mode) -> list[str]:
    """Overall Terraform module customization."""
    return [
        "-var",
        "create_model=false",
        "-var",
        "model=inference-test",
        "-var",
        f"risk={risk}",
        "-var",
        f"kserve_mode={kserve_mode}",
    ]
