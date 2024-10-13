<script setup lang="ts">
import useUsers from "~/composables/useUsers";
import {ref} from "vue";
import type {User} from "~/types/user";
import {useRoute} from "#vue-router";
import BaseButton from "~/components/buttons/BaseButton.vue";
import CancelButton from "~/components/buttons/CancelButton.vue";

const route = useRoute();
const { getUserById, updateUser } = useUsers();
const user = ref<User | null>(null);
const selectedRole = ref<string>(user.role);

onMounted(async () => {
  await onInit();
});

async function onInit() {
  try {
    const userId = route.params.id;
    if (userId) {
      const userData = await getUserById(userId);
      user.value = userData;
      selectedRole.value = user.value.role || "";
    }
  } catch (error) {
    console.error("Erreur lors de la récupération de l'utilisateur :", error);
  }
}

async function onUpdate() {
  try {
    user.value.role = selectedRole.value;
    await updateUser(user.value);
    await navigateTo("/dashboard")
  } catch (error) {
    console.error(error);
  }
}
</script>

<template>
  <div v-if="user">
    <div class="flex flex-col">
      <div class="card-container">
        <h1 class="text-center">{{ $t("utils.edit") }} {{ user.firstName }}</h1>
        <form @submit.prevent="onUpdate" class="text-left">
          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="email">{{ $t("auth.email") }}</label>
            <input id="email" type="email" v-model="user.email" required :placeholder="$t('auth.email-placeholder')" class="rounded-lg"/>
          </div>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="firstName">{{ $t("users.firstName") }}</label>
            <input id="firstName" type="text" v-model="user.firstName" required :placeholder="$t('auth.email-placeholder')" class="rounded-lg"/>
          </div>

          <div class="flex flex-col mb-1">
            <label class="text-white text-opacity-50 text-sm mb-1" for="lastName">{{ $t("users.lastName") }}</label>
            <input id="lastName" type="text" v-model="user.lastName" required :placeholder="$t('auth.email-placeholder')" class="rounded-lg"/>
          </div>

          <fieldset class="flex flex-row justify-around border rounded mb-2">
            <legend class="p-0.5 ml-2">{{ $t("users.role.title") }}</legend>
              <div class="mb-2">
                <input type="radio" class="rounded text-violet" value="admin" v-model="selectedRole"/>
                <label class="ml-1"> {{ $t("users.role.admin") }}</label>
              </div>
              <div class="mb-3 ml-2">
                <input type="radio" class="rounded text-violet" value="member" v-model="selectedRole"/>
                <label class="ml-1"> {{ $t("users.role.member") }}</label>
              </div>
          </fieldset>

          <div class="text-center">
            <BaseButton class="bg-violet hover:bg-violet-dark" type="submit"> {{ $t("utils.update") }} </BaseButton>
            <CancelButton/>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
