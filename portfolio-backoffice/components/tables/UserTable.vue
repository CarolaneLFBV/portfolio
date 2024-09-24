<script setup lang="ts">
import useUsers from "~/composables/useUsers";
import {onMounted, ref} from 'vue';
import {useRouter} from "#vue-router";
import type {User} from "~/types/user";

const { getUsers } = useUsers();
const router = useRouter();
const users = ref<User[]>([]);

onMounted(async () => {
  try {
    users.value = await getUsers();
  } catch (error) {
    console.error(error);
  }
})

function editUser(id: string) {
  router.push(`/users/${id}`);
}
</script>

<template>
  <div v-if="users">
    <h2>Liste des utilisateurs</h2>
    <table>
      <thead>
      <tr>
        <th>Prénom</th>
        <th>Prénom</th>
        <th>Nom</th>
        <th>Email</th>
        <th>Rôle</th>
        <th>Edit</th>
      </tr>
      </thead>
      <tbody>
      <tr v-for="user in users" :key="user.id">
        <td>{{ user.id }}</td>
        <td>{{ user.firstName }}</td>
        <td>{{ user.lastName }}</td>
        <td>{{ user.email }}</td>
        <td>{{ user.role }}</td>
        <td>
          <button @click="editUser(user.id)">Edit</button>
        </td>
      </tr>
      </tbody>
    </table>
  </div>
  <div v-else>
    <p>Chargement de la liste des utilisateurs...</p>
  </div>
</template>

<style scoped>

</style>