<script setup lang="ts">
import {definePageMeta} from "#imports";
import {useAuthStore} from "~/stores/useAuthStore";
import { useRouter } from 'vue-router';
import {useUserStore} from "~/stores/useUserStore";
import UserCard from "~/components/cards/UserCard.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

const {user, isAdmin} = useAuthStore();
const {getAuthenticatedUser} = useUserStore();
const router = useRouter()

onMounted(async () => {
  await onInit();
})

async function onInit() {
  try {
    await getAuthenticatedUser();
  } catch (error) {
    console.log(error);
    await router.push('/auth/login');
  }
}
</script>

<template>
  <div v-if="isAdmin">
    <h2>{{ $t("dashboard.users-list") }}</h2>
    <UserCard/>
  </div>

  <div>
    <h2>Your Informations</h2>
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
</template>

<style scoped>

</style>