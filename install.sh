#!/bin/bash

./scripts/00-install-tap-package.sh

./scripts/02-install-generate-value.sh

./scripts/03-install-tap.sh

# Optional only if your K8S running at AWS
# ./scripts/04-install-external-dns.sh

./scripts/04-install-gui-ingress.sh

./scripts/05-install-dev-namespace.sh