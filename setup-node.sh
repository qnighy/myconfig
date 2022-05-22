#!/usr/bin/env bash
set -ue

curl https://get.volta.sh | bash
volta install node
volta install yarn
volta install corepack
