FROM python:3.11-slim AS dataset 

WORKDIR /app

#Installation de kaggle et de unzip
RUN apt-get update && apt-get install -y unzip
RUN pip install kaggle


# Télécharger et dézipper le dataset
RUN kaggle datasets download -d asaniczka/tmdb-movies-dataset-2023-930k-movies -p /app/data
RUN unzip /app/data/tmdb-movies-dataset-2023-930k-movies.zip -d /app/data

# Étape 2 : image PostgreSQL
FROM postgres:18.3

# Copier les données et scripts depuis l'étape précédente
COPY --from=dataset /app/data/TMDB_movie_dataset_v11.csv /docker-entrypoint-initdb.d/
COPY ./init.sql /docker-entrypoint-initdb.d/

EXPOSE 5432