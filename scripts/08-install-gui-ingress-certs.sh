#!/bin/bash

# install certificate is optional
# ytt --ignore-unknown-comments -f values.yaml -f ingress-config/certificate.yaml | kubectl apply -f- 
# ytt --ignore-unknown-comments -f values.yaml -f ingress-config/cnr-certificate.yaml | kubectl apply -f- 
# ytt --ignore-unknown-comments -f values.yaml -f ingress-config/lets-encrypt-cluster-issuer.yaml | kubectl apply -f- 
# ytt --ignore-unknown-comments -f values.yaml -f ingress-config/ltls-cert-delegation.yaml | kubectl apply -f- 

ytt --ignore-unknown-comments -f values.yaml -f ingress-config/tap-gui-ingress-tlsselfsign.yaml | kubectl apply -f- 