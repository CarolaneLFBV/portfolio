<script setup lang="ts">
import {definePageMeta} from "#imports";
import {useAuthStore} from "~/stores/useAuthStore";
import { useRouter } from 'vue-router';

definePageMeta({
  title: 'Dashboard',
  middleware: 'auth',
})

const {logout, getAuthenticatedUser, user} = useAuthStore();
const router = useRouter()

onMounted(async () => {
  await getAuthenticatedUser();
})


async function onLogout() {
  try {
    await logout();
    await router.push('/auth/login');
  } catch (error) {
    console.log(error);
  }
}
</script>

<template>
  <div class="dashboard">
    <h1>Dashboard</h1>

    <!-- Afficher les informations de l'utilisateur connecté -->
    <div v-if="user">
      <p><strong>First Name:</strong> {{ user.firstName }}</p>
      <p><strong>Last Name:</strong> {{ user.lastName }}</p>
      <p><strong>Email:</strong> {{ user.email }}</p>
      <p><strong>Role:</strong> {{ user.role }}</p>
    </div>

    <div v-else>
      <p>Loading user data...</p>
    </div>

    <button @click="onLogout">Deconnexion</button>
  </div>
</template>

<style scoped>

</style>