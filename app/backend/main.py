import os
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, text
from fastapi.responses import RedirectResponse
import math
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
def get_all_films(page: int = 1):
    limit = 104
    offset = (page - 1) * limit # Les i * limit films sont ignorés lorsqu'on regarde la i-ème page

    with engine.connect() as connection:
        # Recupère le nombre de film
        total = connection.execute(text("SELECT COUNT(*) FROM films WHERE adult IS DISTINCT FROM true AND poster_path IS NOT NULL")).scalar() 

        result = connection.execute(text("SELECT * FROM films WHERE adult IS DISTINCT FROM true AND poster_path IS NOT NULL LIMIT :limit OFFSET :offset"),
            {"limit": limit, "offset": offset})

        return {"films": [dict(row._mapping) for row in result], "total": total, "page": page, "pages": math.ceil(total / limit)}


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
def search_films(titre: str, page: int = 1):
    limit = 100
    offset = (page - 1) * limit

    with engine.connect() as connection:
        total = connection.execute(text("SELECT COUNT(*) FROM films WHERE title ILIKE :recherche AND adult IS DISTINCT FROM true AND poster_path IS NOT NULL"),
            {"recherche": f"%{titre}%"}).scalar()

        result = connection.execute(text("""SELECT * FROM films WHERE title ILIKE :recherche AND adult IS DISTINCT FROM true AND poster_path IS NOT NULL LIMIT :limit OFFSET :offset"""),
            {"recherche": f"%{titre}%", "limit": limit, "offset": offset}
        )

        return {"films": [dict(row._mapping) for row in result], "total": total, "page": page, "pages": math.ceil(total / limit)
        }