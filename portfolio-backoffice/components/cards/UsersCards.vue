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
  <div v-if="users" class="flex flex-row flex-wrap items-start">
    <div v-for="user in users" :key="user.id" class="card-container text-white">
      <div class="flex flex-row">
        <h3 class="text-violet-light font-semibold"> {{ $t("user.fullName") }}: </h3>
        <p class="ml-1"> {{ user.firstName }} {{ user.lastName }} </p>
      </div>

      <div class="flex flex-row">
        <h3 class="text-violet-light font-semibold"> {{ $t("user.email") }}: </h3>
        <p class="ml-1"> {{ user.email }} </p>
      </div>

      <div class="flex flex-row">
        <h3 class="text-violet-light font-semibold"> {{ $t("user.role") }}: </h3>
        <p class="ml-1"> {{ user.role }} </p>
      </div>

      <div class="text-right">
        <BaseButton @click="editUser(user.id)"> {{ $t("utils.edit") }} </BaseButton>
      </div>
    </div>
  </div>
  <div v-else>
    <p>Chargement de la liste des utilisateurs...</p>
  </div>
</template>

<style scoped>

</style>