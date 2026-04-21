#!/bin/bash

# Supprime toutes les ressources Kubernetes deployees
echo "Suppression des configurations"
kubectl delete -f minikube_config/ingress.yaml --ignore-not-found
kubectl delete -f minikube_config/frontend.yaml --ignore-not-found
kubectl delete -f minikube_config/backend.yaml --ignore-not-found
kubectl delete -f minikube_config/db.yaml --ignore-not-found
kubectl delete -f minikube_config/configmap.yaml --ignore-not-found
kubectl delete secret variable --ignore-not-found

# Supprime les images Docker
echo "Suppression des images Docker"
eval $(minikube docker-env)
docker rmi -f projetdocker_m1_crv-db:latest || true
docker rmi -f projetdocker_m1_crv-backend:latest || true
docker rmi -f projetdocker_m1_crv-frontend:latest || true

# Supprime toutes les données du cluster de minikube
echo "Suppression des données du cluster Minikube"
minikube delete

# Tue tous les processus port-forward encore actifs
echo "Arret des port-forwards"
pkill -f "kubectl port-forward" || true
