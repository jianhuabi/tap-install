#!/bin/bash


# install GUI Ingress via Contour httpproxy API
kubectl create ns tanzu-system-ingress

# install ingress httpproxy
ytt --ignore-unknown-comments -f values.yaml -f ingress-config/tap-gui-ingress-tlsselfsign.yaml | kubectl apply -f- 
ytt --ignore-unknown-comments -f values.yaml -f ingress-config/api-portal-ingress.yaml | kubectl apply -f- 
ytt --ignore-unknown-comments -f values.yaml -f ingress-config/metadata-store-ingress.yaml | kubectl apply -f- 

# install certificate is optional
# ytt --ignore-unknown-comments -f values.yaml -f ingress-config/certificate.yaml | kubectl apply -f- 
# ytt --ignore-unknown-comments -f values.yaml -f ingress-config/cnr-certificate.yaml | kubectl apply -f- 
# ytt --ignore-unknown-comments -f values.yaml -f ingress-config/lets-encrypt-cluster-issuer.yaml | kubectl apply -f- 
# ytt --ignore-unknown-comments -f values.yaml -f ingress-config/tls-cert-delegation.yaml | kubectl apply -f- 


# ytt --ignore-unknown-comments -f values.yaml -f external-dns/ | kubectl apply -f- -n tanzu-system-ingress