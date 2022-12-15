#!/bin/bash

# configure developer namespace
DEVELOPER_NAMESPACE=$(yq e .developer_namespace values.yaml)
kubectl create ns $DEVELOPER_NAMESPACE
# install gcr.io registry
export CONTAINER_REGISTRY_HOSTNAME=$(yq e .container_registry.hostname values.yaml)
export CONTAINER_REGISTRY_USERNAME=$(yq e .container_registry.username values.yaml)
export CONTAINER_REGISTRY_PASSWORD=$(yq e .container_registry.password values.yaml)
# tanzu secret registry add registry-credentials --username ${CONTAINER_REGISTRY_USERNAME} --password ${CONTAINER_REGISTRY_PASSWORD} --server ${CONTAINER_REGISTRY_HOSTNAME} --namespace ${DEVELOPER_NAMESPACE}

REGISTRY_PASSWORD=${CONTAINER_REGISTRY_PASSWORD} kp secret create registry-credentials --registry ${CONTAINER_REGISTRY_HOSTNAME} --registry-user ${CONTAINER_REGISTRY_USERNAME} --namespace ${DEVELOPER_NAMESPACE}

export DOCKER_REGISTRY_HOSTNAME=$(yq e .docker_registry.hostname values.yaml)
export DOCKER_REGISTRY_USERNAME=$(yq e .docker_registry.username values.yaml)
export DOCKER_REGISTRY_PASSWORD=$(yq e .docker_registry.password values.yaml)
tanzu secret registry add registry-docker-credentials --username ${DOCKER_REGISTRY_USERNAME} --password ${DOCKER_REGISTRY_PASSWORD} --server ${DOCKER_REGISTRY_HOSTNAME} --namespace ${DEVELOPER_NAMESPACE}

# for tekton to access gcr.io
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "registry-credentials"}]}' -n ${DEVELOPER_NAMESPACE}

export GIT_PASSWORD=$(yq e .gitops.git_password values.yaml)
export GIT_USERNAME=$(yq e .gitops.git_username values.yaml)

cat <<EOF | kubectl -n $DEVELOPER_NAMESPACE apply -f -

apiVersion: v1
kind: Secret
metadata:
  name: tap-registry
  annotations:
    secretgen.carvel.dev/image-pull-secret: ""
type: kubernetes.io/dockerconfigjson
data:
  .dockerconfigjson: e30K
---
apiVersion: v1
kind: Secret
metadata:
  name: git-ssh 
  annotations:
    tekton.dev/git-0: https://github.com        
type: kubernetes.io/basic-auth          
stringData:
  username: ${GIT_USERNAME}
  password: ${GIT_PASSWORD}
---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: default
secrets:
  - name: registry-credentials
  - name: git-ssh
imagePullSecrets:
  - name: registry-credentials
  - name: registry-docker-credentials
  - name: tap-registry

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: default
rules:
- apiGroups: [source.toolkit.fluxcd.io]
  resources: [gitrepositories]
  verbs: ['*']
- apiGroups: [source.apps.tanzu.vmware.com]
  resources: [imagerepositories]
  verbs: ['*']
- apiGroups: [carto.run]
  resources: [deliverables, runnables]
  verbs: ['*']
- apiGroups: [kpack.io]
  resources: [images]
  verbs: ['*']
- apiGroups: [conventions.apps.tanzu.vmware.com]
  resources: [podintents]
  verbs: ['*']
- apiGroups: [conventions.carto.run]
  resources: [podintents]
  verbs: ['*']
- apiGroups: [""]
  resources: ['configmaps']
  verbs: ['*']
- apiGroups: [""]
  resources: ['pods']
  verbs: ['list']
- apiGroups: ["apps"]
  resources: ['*']
  verbs: ['*']
- apiGroups: [tekton.dev]
  resources: [taskruns, pipelineruns]
  verbs: ['*']
- apiGroups: [tekton.dev]
  resources: [pipelines]
  verbs: ['list']
- apiGroups: [kappctrl.k14s.io]
  resources: [apps]
  verbs: ['*']
- apiGroups: [serving.knative.dev]
  resources: ['services']
  verbs: ['*']
- apiGroups: [servicebinding.io]
  resources: ['servicebindings']
  verbs: ['*']
- apiGroups: [services.apps.tanzu.vmware.com]
  resources: ['resourceclaims']
  verbs: ['*']
- apiGroups: [scanning.apps.tanzu.vmware.com]
  resources: ['imagescans', 'sourcescans']
  verbs: ['*']
- apiGroups: [apis.apps.tanzu.vmware.com]
  resources: ['apidescriptors']
  verbs: ['*']
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: default
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: default
subjects:
  - kind: ServiceAccount
    name: default

EOF
