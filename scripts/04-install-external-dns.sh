#!/bin/bash


# install external dns

# ytt --ignore-unknown-comments -f values.yaml -f ingress-config/ | kubectl apply -f- 

ytt --ignore-unknown-comments -f values.yaml -f external-dns/ | kubectl apply -f- -n tanzu-system-ingress