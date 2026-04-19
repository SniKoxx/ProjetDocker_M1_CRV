import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, text
from fastapi.responses import RedirectResponse

# Initialisation de l'application FastAPI
app = FastAPI()

# Autorisation de communiquer entre le backend frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Connexion à la base de données PostgreSQL 
DATABASE_URL = os.getenv("DATABASE_URL")
engine = create_engine(DATABASE_URL, pool_pre_ping=True)

@app.get("/")
def root():
    # Redirection vers /films pour afficher le catalogue
    return RedirectResponse(url="/films")

@app.get("/films")
def get_all_films():
    limit = 100

    #Affiche 50 films sur la page d'accueil
    with engine.connect() as connection:
        result = connection.execute(
            text("SELECT * FROM films WHERE adult IS DISTINCT FROM true and poster_path IS NOT NULL ORDER BY RANDOM() LIMIT :limit"),
            {"limit": limit}
        )
        return [dict(row._mapping) for row in result]

@app.get("/films/{film_id}")
def get_film_by_id(film_id: int):
    
    #Lorsqu'on va séléctionner un film depuis le frontend, on recupèrera les informations du film séléctionner
    with engine.connect() as connection:
        result = connection.execute(text("SELECT * FROM films WHERE id = :id"), {"id": film_id})
        film = result.fetchone()
        
        if film is None:
            # Si le film n'existe pas, on renvoie une erreur 404
            raise HTTPException(status_code=404, detail="Film non trouvé")
            
        return dict(film._mapping)

@app.get("/search/{titre}")
def search_films(titre: str):
    
    #Recherche des films comportant le mot dans son titre
    with engine.connect() as connection:
        # ILIKE permet de chercher sans prendre en compte la majuscule/minuscule
        query = text("SELECT * FROM films WHERE title ILIKE :recherche and adult IS DISTINCT FROM true and poster_path IS NOT NULL")
        # Cherche dans tout les titres si il comporte le mot {titre}
        result = connection.execute(query, {"recherche": f"%{titre}%"})
        return [dict(row._mapping) for row in result]