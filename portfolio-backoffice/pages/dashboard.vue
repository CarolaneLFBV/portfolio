<script setup lang="ts">
import {definePageMeta} from "#imports";
import {useAuthStore} from "~/stores/useAuthStore";
import { useRouter } from 'vue-router';
import {useUserStore} from "~/stores/useUserStore";
import UsersCards from "~/components/cards/UsersCards.vue";
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
  <main>
    <div v-if="isAdmin">
      <h1>{{ $t("dashboard.users-list") }}</h1>
      <UsersCards/>
    </div>

    <div v-else>
      <h1>Your Informations</h1>
      <UserCard/>
    </div>
  </main>
</template>

<style scoped>

</style>