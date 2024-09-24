<script setup lang="ts">
import {useAuthStore} from "~/stores/useAuthStore";
import useUsers from "~/composables/useUsers";

const {register} = useAuthStore();
const {user} = useUsers();

async function onRegister() {
  try {
    await register({
      email: user.value.email,
      password: user.value.password,
      role: 'member',
    })
  } catch (error) {
    console.log(error);
  }
}
</script>

<template>
  <form @submit.prevent="onRegister">
    <div>
      <label for="email">Email</label>
      <input type="email" id="email" v-model="user.email" required />
    </div>
    <div>
      <label for="password">Mot de passe</label>
      <input type="password" id="password" v-model="user.password" required />
    </div>
    <button type="submit">S'inscrire</button>
  </form>
</template>

<style scoped>

</style>