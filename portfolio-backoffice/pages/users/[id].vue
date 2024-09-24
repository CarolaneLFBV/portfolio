<script setup lang="ts">
import useUsers from "~/composables/useUsers";
import { ref } from 'vue';
import {definePageMeta} from "#imports";
import type {User} from "~/types/user";
import {useRoute} from "#vue-router";

definePageMeta({
  title: 'Edit',
  middleware: ['auth'],
})

const { getUserById, updateUser } = useUsers();
const user = ref<User | null>(null);
const route = useRoute();

onMounted(async () => {
  await onInit();
});

async function onInit() {
  try {
    const userId = route.params.id;
    if (userId) {
      const userData = await getUserById(userId);
      user.value = userData;
    }
  } catch (error) {
    console.error("Erreur lors de la récupération de l'utilisateur :", error);
  }
}

async function update() {
  try {
    await updateUser(user.value);
  } catch (error) {
    console.error(error);
  }
}
</script>

<template>
  <div v-if="user">
    <form @submit.prevent="update">
      <input v-model="user.email" id="email" type="email" />
      <button type="submit">Mettre à jour</button>
    </form>
  </div>
</template>


<style scoped>

</style>