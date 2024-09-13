<script setup lang="ts">

import {useUserStore} from "~/stores/useUserStore";

const userStore = useUserStore();
const email = ref("");
const password = ref("");
const isAdmin = ref(false);

const handleRegister = async () => {
  try {
    await userStore.register(email.value, password.value, isAdmin.value);
  } catch (e) {
    console.error("Erreur API : ", e);
  }
}

</script>

<template>
  <form @submit.prevent="handleRegister">
    <div>
      <label for="email">Email</label>
      <input type="email" id="email" v-model="email" required />
    </div>
    <div>
      <label for="password">Mot de passe</label>
      <input type="password" id="password" v-model="password" required />
    </div>
    <div>
      <label for="adminSwitch">Activer l'administrateur :</label>
      <input type="checkbox" id="adminSwitch" v-model="isAdmin" />
    </div>
    <button type="submit">S'inscrire</button>
  </form>
</template>

<style scoped>

</style>