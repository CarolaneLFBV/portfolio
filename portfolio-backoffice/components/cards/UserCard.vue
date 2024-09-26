<script setup lang="ts">
import useUsers from "~/composables/useUsers";
import {onMounted, ref} from 'vue';
import {useRouter} from "#vue-router";
import type {User} from "~/types/user";

const { getUsers } = useUsers();
const router = useRouter();
const users = ref<User[]>([]);
onMounted(async () => {
  await onInit();
})

async function onInit() {
  try {
    users.value = await getUsers();
  } catch (error) {
    console.error(error);
  }
}

function editUser(id: string) {
  router.push(`/users/${id}`);
}
</script>

<template>
  <div v-if="users" class="flex-row flex-wrap">
    <div v-for="user in users" :key="user.id" class="card-container margin text-align-left">
      <p><strong>{{ $t("user.fullName") }}:</strong> {{ user.firstName }} {{ user.lastName }} </p>
      <p><strong>{{ $t("user.email") }}:</strong> {{ user.email }}</p>
      <p><strong>{{ $t("user.role") }}:</strong> {{ user.role }}</p>
      <div class="text-align-right"><button @click="editUser(user.id)">Edit</button></div>
    </div>
  </div>
  <div v-else>
    <p>Chargement de la liste des utilisateurs...</p>
  </div>
</template>

<style scoped>
strong {
  color: var(--caption-color)
}
</style>