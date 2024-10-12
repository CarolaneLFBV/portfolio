<script setup lang="ts">
import useUsers from "~/composables/useUsers";
import {onMounted, ref} from 'vue';
import {useRouter} from "#vue-router";
import type {User} from "~/types/user";
import BaseButton from "~/components/buttons/BaseButton.vue";
import DeleteButton from "~/components/buttons/DeleteButton.vue";

const { getUsers, deleteUser } = useUsers();
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

function onEdit(id: string) {
  router.push(`/users/${id}`);
}

async function onDelete(id: string) {
  try {
    await deleteUser(id);
    users.value = await getUsers();
  } catch (error) {
    console.error(error);
  }
}

</script>

<template>
  <div v-if="users" class="flex flex-row flex-wrap">
    <div v-for="user in users" :key="user.id" class="card-container text-white">
      <div class="flex flex-row">
        <h3 class="text-violet font-semibold"> {{ $t("user.fullName") }}: </h3>
        <p class="ml-1"> {{ user.firstName }} {{ user.lastName }} </p>
      </div>

      <div class="flex flex-row">
        <h3 class="text-violet font-semibold"> {{ $t("user.email") }}: </h3>
        <p class="ml-1"> {{ user.email }} </p>
      </div>

      <div class="flex flex-row">
        <h3 class="text-violet font-semibold"> {{ $t("user.role") }}: </h3>
        <p class="ml-1"> {{ user.role }} </p>
      </div>

      <div class="text-right">
        <BaseButton class="mx-2" @click="onEdit(user.id)">{{ $t("utils.edit") }}</BaseButton>
        <DeleteButton @click="onDelete(user.id)">{{ $t("utils.delete") }}</DeleteButton>
      </div>
    </div>
  </div>
  <div v-else>
    <p>Chargement de la liste des utilisateurs...</p>
  </div>
</template>
