<template>
  <div class="container py-3">

    <!-- SEARCH -->
    <div class="mb-3">
      <SearchBar @search="searchMovies" />
    </div>

    <!-- MOVIES -->
    <MovieList :movies="movies" />

  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import SearchBar from '../components/SearchBar.vue'
import MovieList from '../components/MovieList.vue'

const API = "http://localhost:8000"
const movies = ref([])

const load = async () => {
  const res = await fetch(`${API}/films`)
  movies.value = await res.json()
}

const searchMovies = async (query) => {
  if (!query) {
    return load();
  }
  const res = await fetch(`${API}/search/${query}`)
  movies.value = await res.json()
}

onMounted(async () => {
  await load()
  console.log("MOVIES:", movies.value)
})
</script>