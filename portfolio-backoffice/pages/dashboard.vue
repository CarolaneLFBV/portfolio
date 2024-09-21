<script setup lang="ts">
import {definePageMeta} from "#imports";
import {useAuthStore} from "~/stores/useAuthStore";
import { useRouter } from 'vue-router';

definePageMeta({
  title: 'Dashboard',
  middleware: 'auth',
})

const {logout} = useAuthStore();
const router = useRouter()

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
  <div>
    Dashboard
    <button @click="onLogout">Deconnexion</button>
  </div>
</template>

<style scoped>

</style>