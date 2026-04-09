-- Table temporaire pour absorber tous les doublons et les données brutes
CREATE TEMP TABLE films_staging (
    id BIGINT,
    title TEXT,
    vote_average NUMERIC,
    vote_count INT,
    status TEXT,
    release_date TEXT, -- Possibilité qu'il soit vide, sinon on aurait pu mettre DATE
    revenue BIGINT,
    runtime INT,
    adult BOOLEAN,
    backdrop_path TEXT,
    budget BIGINT,
    homepage TEXT,
    imdb_id TEXT,
    original_language TEXT,
    original_title TEXT,
    overview TEXT,
    popularity NUMERIC,
    poster_path TEXT,
    tagline TEXT,
    genres TEXT,
    production_companies TEXT,
    production_countries TEXT,
    spoken_languages TEXT,
    keywords TEXT
);

-- Import brut du CSV dans la table staging
COPY films_staging(
    id, title, vote_average, vote_count, status, release_date,
    revenue, runtime, adult, backdrop_path, budget, homepage,
    imdb_id, original_language, original_title, overview,
    popularity, poster_path, tagline, genres, production_companies,
    production_countries, spoken_languages, keywords
)
FROM '/docker-entrypoint-initdb.d/TMDB_movie_dataset_v11.csv'
DELIMITER ','
CSV HEADER;

-- Remplace les "" en NULL sur toutes les colonnes TEXT
UPDATE films_staging
SET
    title                = NULLIF(title, ''),
    status               = NULLIF(status, ''),
    release_date         = NULLIF(release_date, ''),
    backdrop_path        = NULLIF(backdrop_path, ''),
    homepage             = NULLIF(homepage, ''),
    imdb_id              = NULLIF(imdb_id, ''),
    original_language    = NULLIF(original_language, ''),
    original_title       = NULLIF(original_title, ''),
    overview             = NULLIF(overview, ''),
    poster_path          = NULLIF(poster_path, ''),
    tagline              = NULLIF(tagline, ''),
    genres               = NULLIF(genres, ''),
    production_companies = NULLIF(production_companies, ''),
    production_countries = NULLIF(production_countries, ''),
    spoken_languages     = NULLIF(spoken_languages, ''),
    keywords             = NULLIF(keywords, '');

-- Création de la table finale
CREATE TABLE films (
    id                   BIGINT PRIMARY KEY,
    title                TEXT,
    vote_average         NUMERIC,
    vote_count           INT,
    status               TEXT,
    release_date         DATE,
    revenue              BIGINT,
    runtime              INT,
    adult                BOOLEAN,
    backdrop_path        TEXT,
    budget               BIGINT,
    homepage             TEXT,
    imdb_id              TEXT,
    original_language    TEXT,
    original_title       TEXT,
    overview             TEXT,
    popularity           NUMERIC,
    poster_path          TEXT,
    tagline              TEXT,
    genres               TEXT,
    production_companies TEXT,
    production_countries TEXT,
    spoken_languages     TEXT,
    keywords             TEXT
);

-- Insertion des films dans la table, sans avoir de doublons
INSERT INTO films
SELECT DISTINCT ON (id)
    id, title, vote_average, vote_count, status,
    release_date::DATE,
    revenue, runtime, adult, backdrop_path, budget, homepage,
    imdb_id, original_language, original_title, overview,
    popularity, poster_path, tagline, genres, production_companies,
    production_countries, spoken_languages, keywords
FROM films_staging
ORDER BY id;

-- Suppression de la table temporaire
DROP TABLE films_staging;