#!/bin/bash


# install GUI Ingress via Contour httpproxy API
kubectl create ns tanzu-system-ingress

ytt --ignore-unknown-comments -f values.yaml -f ingress-config/ | kubectl apply -f- 

# ytt --ignore-unknown-comments -f values.yaml -f external-dns/ | kubectl apply -f- -n tanzu-system-ingress