import type { RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    name: 'home',
    component: () => import('../views/HomeView.vue'),
  },
  {
    path: '/qa',
    name: 'qa',
    component: () => import('../views/QuestionsView.vue'),
  },
]

export default routes
