<script setup lang="ts">
import {definePageMeta} from "#imports";
import UsersCards from "~/components/cards/UserCard.vue";
import BaseButton from "~/components/buttons/BaseButton.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: ['auth'],
})

function createUser() {
  navigateTo("/auth/register");
}
</script>

<template>
  <main>
    <div class="mb-4">
      <h1>{{ $t("users.list") }}</h1>
      <BaseButton class="bg-violet hover:bg-violet-dark" @click="createUser">{{ $t("utils.create") }}</BaseButton>
    </div>
    <UsersCards/>
  </main>
</template>

<style scoped>

</style>