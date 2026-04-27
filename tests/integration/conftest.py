import pytest


def pytest_addoption(parser):
    """Add CLI options to pytest."""
    parser.addoption(
        "--kserve-mode",
        nargs="?",
        choices=["knative", "standard"],
        const="knative",
        default="knative",
        type=str,
        help="KServe mode",
    )


@pytest.fixture(scope="module")
def kserve_mode(request) -> list[str]:
    """KServe mode."""
    return request.config.getoption("--kserve-mode")


@pytest.fixture(scope="module")
def tf_vars(kserve_mode) -> list[str]:
    """Overall Terraform module customization."""
    return [
        "-var",
        "create_model=false",
        "-var",
        "model=inference-test",
        "-var",
        f"kserve_mode={kserve_mode}",
    ]
