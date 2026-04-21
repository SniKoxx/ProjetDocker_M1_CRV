#!/bin/bash

# Verifie que Docker, kubectl et minikube sont installes
command -v docker >/dev/null || { echo "docker manquant"; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl manquant"; exit 1; }
command -v minikube >/dev/null || { echo "minikube manquant"; exit 1; }

echo "Lancement de minikube"
minikube status | grep -q "Running" || minikube start --driver=docker

# Utilisation du docker de minikube, et non celui de mon PC
eval $(minikube docker-env)

echo "Build des images docker"
docker compose build

# Supprime le secret s'il existe déjà pour eviter un conflit puis le recrée depuis le fichier .env.
echo "Creation du Secret Kubernetes"
kubectl delete secret variable --ignore-not-found > /dev/null 2>&1
kubectl create secret generic variable --from-env-file=.env

# Applique toutes les configurations défini
echo "Deploiement des configurations"
kubectl apply -f minikube_config/configmap.yaml
kubectl apply -f minikube_config/db.yaml
kubectl apply -f minikube_config/backend.yaml
kubectl apply -f minikube_config/frontend.yaml
kubectl apply -f minikube_config/ingress.yaml

# Attend que chaque pod soit dans l'état "Ready" avant de continuer
echo "Attente des pods"
kubectl wait --for=condition=ready pod -l app=db --timeout=180s
kubectl wait --for=condition=ready pod -l app=backend --timeout=120s
kubectl wait --for=condition=ready pod -l app=frontend --timeout=120s

# Sur mac le réseau est isolé entre l'ordinateur et minikube donc il faut crée un tunnel qui reliera les 2 pour pouvoir accéder à l'application web. On utilisera pas ingress dans ce cas la.
echo "Demarrage du port-forward"
kubectl port-forward service/frontend 8080:80 &

PF_PID=$!
sleep 2
echo ""
echo "Application disponible sur : http://localhost:8080"

wait $PF_PID