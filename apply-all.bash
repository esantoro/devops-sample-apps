#!/usr/bin/env bash

helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/

helm upgrade \
     --namespace metrics-server --create-namespace \
     --install --wait \
     metrics-server metrics-server/metrics-server

kubectl apply -f golang/k8s/sample-golang.yaml
kubectl apply -f php/k8s/sample-php.yaml
