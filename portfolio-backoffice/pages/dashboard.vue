<script setup lang="ts">
import {definePageMeta} from "#imports";
import {useAuthStore} from "~/stores/useAuthStore";
import { useRouter } from 'vue-router';
import {useUserStore} from "~/stores/useUserStore";
import UserTable from "~/components/tables/UserTable.vue";

definePageMeta({
  title: 'Dashboard',
  middleware: 'auth',
})

const {user, isAdmin} = useAuthStore();
const {getAuthenticatedUser} = useUserStore();
const router = useRouter()

onMounted(async () => {
  try {
    await getAuthenticatedUser();
  } catch (error) {
    console.log(error);
    await router.push('/auth/login');
  }
})
</script>

<template>
  <div class="dashboard">
    <h1>Dashboard</h1>
    <div v-if="isAdmin">
      <UserTable/>
    </div>

    <div>
      <h1>Information</h1>
      <div v-if="user">
        <p><strong>First Name:</strong>{{ user.firstName }}</p>
        <p><strong>Last Name:</strong>{{ user.lastName }}</p>
        <p><strong>Email:</strong>{{ user.email }}</p>
        <p><strong>Role:</strong>{{ user.role }}</p>
      </div>

      <div v-else>
        <p>Loading user data...</p>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>