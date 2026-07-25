# Python toolchain configuration
# Manages Python packages, uv, and development tools.

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python3
    uv
    ruff
    python3Packages.pytest
    python3Packages.ipython
    python3Packages.pip
  ];

  home.file.".config/uv/uv.toml".text = ''
    [python]
    python-downloads = "manual"

    index-url = "https://pypi.org/simple"
    respect-gitignore = true
  '';

  home.file.".config/ruff/ruff.toml".text = ''
    line-length = 100
    target-version = "py313"

    lint.select = ["E", "F", "I", "N", "W", "UP"]
  '';

  home.file.".python-version".text = "3.13\n";

  home.sessionVariables = {
    UV_PYTHON_DOWNLOADS = "manual";
    PIP_REQUIRE_VIRTUALENV = "true";
    PYTHONDONTWRITEBYTECODE = "1";
    PYTHONOPTIMIZE = "1";
    PYTHONUNBUFFERED = "1";
  };
}
