#!/bin/bash
set -euo pipefail

# Required
# hugo
# gh

# install hugo somehow
pip install obsidian-to-hugo
git clone https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
echo 'theme = "ananke"' >> config.toml