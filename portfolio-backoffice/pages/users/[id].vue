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

const { getUserById } = useUsers();
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
</script>

<template>
  <div v-if="user">
    <h2>Modifier les informations de l'utilisateur</h2>
    <p>Email : {{ user.email }}</p>
  </div>
  <div v-else>
    <p>Chargement...</p>
  </div>
</template>


<style scoped>

</style>