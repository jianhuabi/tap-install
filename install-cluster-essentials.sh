#!/bin/bash

if [ ! -d "tanzu-cluster-essentials" ] && echo "Directory tanzu-cluster-essentials not exists."; then
    pivnet download-product-files --product-slug='tanzu-cluster-essentials' --release-version='1.0.0' --product-file-id=1105820
    mkdir tanzu-cluster-essentials
    tar -xvf tanzu-cluster-essentials-darwin-amd64-1.0.0.tgz -C tanzu-cluster-essentials
fi

export INSTALL_BUNDLE=registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:82dfaf70656b54dcba0d4def85ccae1578ff27054e7533d08320244af7fb0343

cd tanzu-cluster-essentials
./install.sh
cd ..