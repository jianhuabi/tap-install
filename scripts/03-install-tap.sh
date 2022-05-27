#!/bin/bash

export INSTALL_REGISTRY_HOSTNAME=registry.tanzu.vmware.com
export INSTALL_REGISTRY_USERNAME=$(cat values.yaml | grep tanzunet -A 3 | awk '/username:/ {print $2}')
export INSTALL_REGISTRY_PASSWORD=$(cat values.yaml  | grep tanzunet -A 3 | awk '/password:/ {print $2}')

PROFILE=$(yq e .profile values.yaml)
TAPVER=$(yq e .tap_verion values.yaml)

echo "PROFILE: $PROFILE"
echo "TAPVER: $TAPVER"

if [ "$PROFILE" = "full" ];
then
    
  tanzu package install tap -p tap.tanzu.vmware.com -v $TAPVER --values-file generated/tap-values.yaml -n tap-install

else

  tanzu package install tap -p tap.tanzu.vmware.com -v $TAPVER --values-file generated/tap-values-run.yaml -n tap-install
fi


