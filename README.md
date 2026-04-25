# Projet Conteneurisation 
Ce projet a pour but de crée une application web de catalogue de films avec Docker et Kubernetes. Il est composée d’un frontend, d’un backend et d’une base de données.
 
## Prérequis
- Docker
- Minikube
- Kubernetes

## Configuration
 
Créer un fichier `.env` à la racine du projet :
 
```env
POSTGRES_USER=user
POSTGRES_PASSWORD=password
POSTGRES_DB=liste_movies
DATABASE_URL=postgresql://user:password@db:5432/liste_movies
```

## Lancement
 
**Linux**
```bash
chmod +x run_linux.sh
./run_linux.sh
```
Pour accéder a l'application, il faut aller sur `http://projet.crv`
 
**macOS**
```bash
chmod +x run_mac.sh
./run_mac.sh
```
Pour accéder a l'application, il faut aller sur `http://localhost:8080`
 
## Arrêt
```bash
# Arrêter les services
./stop.sh
```
