#!/bin/bash

mkdir -p generated

ytt -f tap-values.yaml -f values.yaml --ignore-unknown-comments > generated/tap-values.yaml
