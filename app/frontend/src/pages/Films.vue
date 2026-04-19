<template>
  <div class="container py-3">
    <div class="mb-3">
      <SearchBar @search="searchMovies" />
    </div>

    <MovieList :movies="movies" />
    <div v-if="totalPages > 1" class="d-flex justify-content-center gap-2 mt-4">
      <button
        v-for="p in visiblePages"
        :key="p"
        @click="goToPage(p)"
        :class="['btn', p === currentPage ? 'btn-primary' : 'btn-outline-secondary']"
      >
        {{ p }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import SearchBar from '../components/SearchBar.vue'
import MovieList from '../components/MovieList.vue'

const movies = ref([])
const currentPage = ref(1)
const totalPages = ref(1)
const currentQuery = ref("")  

const load = async (page = 1) => {
  try {
    const res = await fetch(`${API}/films?page=${page}`)
    if (!res.ok) {
      throw new Error("Erreur API films")
    }
    const data = await res.json()
    movies.value = data.films
    currentPage.value = data.page
    totalPages.value = data.pages
  } catch (err) {
    console.error(err)
    movies.value = []
  }
}

const searchMovies = async (query, page = 1) => {
  currentQuery.value = query
  try {
    if (!query){
      return load(page)
    }
    const res = await fetch(`${API}/search/${query}?page=${page}`)
    if (!res.ok) {
      throw new Error("Erreur recherche")
    }
    const data = await res.json()
    movies.value = data.films
    currentPage.value = data.page
    totalPages.value = data.pages
  } catch (err) {
    console.error(err)
    movies.value = []
  }
}

const goToPage = (page) => {
  if (currentQuery.value) {
    searchMovies(currentQuery.value, page)
  } else {
    load(page)
  }
}

const visiblePages = computed(() => {
  const total = totalPages.value
  const current = currentPage.value

  let start = Math.max(1, current - 2)
  let end = Math.min(total, start + 4)
  if (end - start < 4) {
    start = Math.max(1, end - 4)
  }

  const pages = []
  for (let i = start; i <= end; i++) {
    pages.push(i)
  }
  return pages
})

onMounted(() => load())
</script>