<template>
  <div class="page">
    <button class="back" @click="router.back()">← Retour</button>
    <div v-if="loading">Chargement...</div>
    <div v-else-if="film" class="container">
      <img
        v-if="film.poster_path"
        :src="`https://image.tmdb.org/t/p/w342${film.poster_path}`"
        class="poster"
      />
      <div class="info">
        <h1>{{ film.title }}</h1>
        <p class="meta">
          ⭐ {{ film.vote_average }} ({{ film.vote_count }})
        </p>
        <p class="meta" v-if="film.release_date">
          Date de sortie : {{ new Date(film.release_date).toLocaleDateString('fr-FR') }}
        </p>
        <p class="meta" v-if="film.runtime">
          Durée du film : {{ film.runtime }} min
        </p>
        <p class="overview" v-if="film.overview">
          {{ film.overview }}
        </p>
        <div class="tags" v-if="film.genres">
          <span
            class="tag"
            v-for="g in splitField(film.genres)"
            :key="g"
          >
            {{ g }}
          </span>
        </div>
      </div>
    </div>
    <div v-else>Film introuvable</div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'


const route = useRoute()
const router = useRouter()

const film = ref(null)
const loading = ref(true)

import {API} from "../main.js"

const splitField = (val) => {
  if (!val){
    return []
  }
  return val.split(',').map(s => s.trim()).filter(Boolean)
}

onMounted(async () => {
  const res = await fetch(`${API}/films/${route.params.id}`)
  film.value = await res.json()
  loading.value = false
})
</script>

<style scoped src="../assets/FilmDetail.css"></style>