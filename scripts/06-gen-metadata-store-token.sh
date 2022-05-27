#!/bin/bash

kubectl get role metadata-store-read-write -n metadata-store &>/dev/null
rc=$?

if [ $rc -eq 0 ]; then
    echo -e "metadata-store-read-write role already exists"
else
    echo -e "Creating metadata-store-read-write role"
    kubectl apply -f - -o yaml << EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: metadata-store-read-write
  namespace: metadata-store
rules:
- resources: ["all"]
  verbs: ["get", "create", "update"]
  apiGroups: [ "metadata-store/v1" ]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: metadata-store-read-write
  namespace: metadata-store
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: metadata-store-read-write
subjects:
- kind: ServiceAccount
  name: metadata-store-read-write-client
  namespace: metadata-store
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: metadata-store-read-write-client
  namespace: metadata-store
automountServiceAccountToken: false
EOF

fi

echo -e "\n" 
echo "copy below metadata-store read-write token to tap-values.yaml for GUI CVE accessing......"
echo -e "\n"

kubectl get secret $(kubectl get sa -n metadata-store metadata-store-read-write-client -o json | jq -r '.secrets[0].name') -n metadata-store -o json | jq -r '.data.token' | base64 -d

