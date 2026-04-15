<template>
  <div class="grid">
    <MovieCard
      v-for="movie in movies"
      :key="movie.id"
      :movie="movie"
    />
  </div>
</template>

<script setup>
import MovieCard from './MovieCard.vue'

defineProps({
  movies: Array
})
</script>

<style>
.grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
  gap: 12px;
}
</style>