<template>
  <div class="container mt-3">
    <div class="input-group">

      <input
        v-model="query"
        type="text"
        class="form-control"
        placeholder="Rechercher un film..."
        @keyup.enter="emitSearch"
      />

      <button class="btn btn-primary" @click="emitSearch">
        Rechercher
      </button>

    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const emit = defineEmits(['search'])
const query = ref('')

const emitSearch = () => {
  emit('search', query.value)
}
</script>
<style>
input {
  padding: 8px;
  width: 250px;
}
</style>
