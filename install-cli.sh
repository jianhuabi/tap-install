#!/bin/bash

pivnet download-product-files --product-slug='tanzu-application-platform' --release-version='1.0.0' --product-file-id=1114446
mkdir tanzu
tar -xvf tanzu-framework-darwin-amd64.tar -C tanzu
export TANZU_CLI_NO_INIT=true
cd tanzu
sudo install cli/core/v0.10.0/tanzu-core-darwin_amd64 /usr/local/bin/tanzu
tanzu version

tanzu plugin install --local cli all
tanzu plugin listcd ..
cd ..