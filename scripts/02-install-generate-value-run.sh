#!/bin/bash

mkdir -p generated

ytt -f tap-values-run.yaml -f values.yaml --ignore-unknown-comments > generated/tap-values-run.yaml
