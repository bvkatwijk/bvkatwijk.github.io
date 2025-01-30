#!/bin/bash
set -euo pipefail

asdf install
brew install hugo
pip install obsidian-to-hugo
git clone https://github.com/budparr/gohugo-theme-ananke.git themes/ananke
echo 'theme = "ananke"' >> config.toml