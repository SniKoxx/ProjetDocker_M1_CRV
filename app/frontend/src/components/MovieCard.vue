<template>
  <div class="card h-100 shadow-sm" @click="goToFilm">
    <img
      :src="`https://image.tmdb.org/t/p/w342${movie.poster_path}`"
      :alt="movie.title"
      class="card-img-top"
    />
    <div class="card-body">
      <h6 class="card-title">{{ movie.title }}</h6>
      <p class="text-muted small mb-0" v-if="movie.release_date">
        {{ new Date(movie.release_date).getFullYear() }}
      </p>
    </div>
  </div>
</template>
<script setup>
import { useRouter } from 'vue-router'

const props = defineProps({
  movie: Object
})

const router = useRouter()

const goToFilm = () => {
  router.push(`/films/${props.movie.id}`)
}
</script>

<style scoped src="../assets/MovieCard.css"></style>
