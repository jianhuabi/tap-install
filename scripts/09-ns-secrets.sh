#!/bin/bash

cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: workload-git-auth
  namespace: tap-install
type: Opaque
stringData:
  content.yaml: |
    git:
      #! For HTTP Auth. Recommend using https:// for the git server.
      host: https://github.com
      username: jianhuabi
      password: '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'
EOF

cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: workload-git-auth-overlay
  namespace: tap-install
  annotations:
    kapp.k14s.io/change-rule: "delete after deleting tap"
stringData:
  workload-git-auth-overlay.yaml: |
    #@ load("@ytt:overlay", "overlay")
    #@overlay/match by=overlay.subset({"apiVersion": "v1", "kind": "ServiceAccount","metadata":{"name":"default"}}), expects="0+"
    ---
    secrets:
    #@overlay/append
    - name: git
EOF