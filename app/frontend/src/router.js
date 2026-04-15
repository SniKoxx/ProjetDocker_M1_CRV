import { createRouter, createWebHistory } from 'vue-router'
import Films from './pages/Films.vue'
import FilmDetail from './pages/FilmDetail.vue'

const routes = [
  { path: '/', redirect: '/films' },
  { path: '/films', component: Films },
  { path: '/films/:id', component: FilmDetail }
]

export default createRouter({
  history: createWebHistory(),
  routes
})