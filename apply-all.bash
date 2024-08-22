#!/usr/bin/env bash

function green {
    tput setaf 2 ; echo $1 ; tput sgr0
}


function cyan {
    tput setaf 6 ; echo $1 ; tput sgr0
}

helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm repo update

/usr/bin/aws eks update-kubeconfig \
	     --region eu-north-1 \
	     --name docplanner-prod

cyan "Installing metrics-server...."

helm upgrade \
     --namespace metrics-server --create-namespace \
     --install --wait \
     metrics-server metrics-server/metrics-server

cyan "Installing ingress-nginx controller...."

helm upgrade --namespace=ingress-nginx --create-namespace \
      --install --wait \
      nginx-ingress-controller ingress-nginx/ingress-nginx \
      --values nginx-ingress-controller-values.yaml

cyan "Installing golang app ..."

kubectl apply -f golang/k8s/sample-golang.yaml

cyan "Installing php app ..."
kubectl apply -f php/k8s/sample-php.yaml

LB_HOSTNAME=$(kubectl -n ingress-nginx get service nginx-ingress-controller-ingress-nginx-controller -o jsonpath="{.status.loadBalancer.ingress[0].hostname}")

green "LoadBalancer at: $LB_HOSTNAME"
green "PHP at: http://${LB_HOSTNAME}/"
green "PHP at: http://${LB_HOSTNAME}/api/v1"
green "GO at: http://${LB_HOSTNAME}/api/v2"
