#!/usr/bin/env bash

helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

/usr/bin/aws eks update-kubeconfig \
	     --region eu-north-1 \
	     --name docplanner-prod

helm upgrade \
     --namespace metrics-server --create-namespace \
     --install --wait \
     metrics-server metrics-server/metrics-server


helm upgrade --namespace=ingress-nginx --create-namespace \
      --install --wait \
      nginx-ingress-controller ingress-nginx/ingress-nginx \
      --values nginx-ingress-controller-values.yaml


kubectl apply -f golang/k8s/sample-golang.yaml
kubectl apply -f php/k8s/sample-php.yaml

LB_HOSTNAME=$(kubectl -n ingress-nginx get service nginx-ingress-controller-ingress-nginx-controller -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

echo "LoadBalancer at: $LB_HOSTNAME"
echo "PHP at: http://${LB_HOSTNAME}/"
echo "PHP at: http://${LB_HOSTNAME}/api/v1"
echo "GO at: http://${LB_HOSTNAME}/api/v2"
