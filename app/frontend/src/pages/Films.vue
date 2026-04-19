<template>
  <div class="container py-3">

    <div class="mb-3">
      <SearchBar @search="searchMovies" />
    </div>

    <MovieList :movies="movies" />

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import SearchBar from '../components/SearchBar.vue'
import MovieList from '../components/MovieList.vue'

import {API} from "../main.js"
const movies = ref([])

const load = async () => {
  try {
    const res = await fetch(`${API}/films`)
    if (!res.ok) {
      throw new Error("Erreur venant du backend")
    }
    movies.value = await res.json()
  } 
  catch (err) {
    console.error(err)
    movies.value = []
  }
}

const searchMovies = async (query) => {
  try {
    if (!query){
      return load()
    }
    const res = await fetch(`${API}/search/${query}`)
    if (!res.ok) {
      throw new Error("Erreur recherche")
    }
    movies.value = await res.json()
  } 
  catch (err) {
    console.error(err)
    movies.value = []
  }
}

onMounted(async () => {
  await load()
  console.log("MOVIES:", movies.value)
})
</script>