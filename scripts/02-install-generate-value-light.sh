#!/bin/bash

mkdir -p generated

ytt -f tap-values-light.yaml -f values.yaml --ignore-unknown-comments > generated/tap-values-light.yaml
