<script setup lang="ts">
import useUsers from "~/composables/useUsers";
import {ref} from "vue";
import type {User} from "~/types/user";
import {useRoute} from "#vue-router";
import {definePageMeta} from "#imports";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: ['auth'],
})


const { getUserById, updateUser } = useUsers();
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

async function update() {
  try {
    await updateUser(user.value);
  } catch (error) {
    console.error(error);
  }
}
</script>




<template>
  <div v-if="user">
    <div class="full-height flex-column text-align-center">
      <div class="card-container text-align-center">
        <h1>{{ $t("edit") }} {{ user.firstName }}</h1>
        <form @submit.prevent="update">
          <div class="padding-bottom text-align-left">
            <label for="email">{{ $t("auth.email") }}</label>
            <input class="full-width" id="email" type="email" v-model="user.email" required :placeholder="$t('auth.email-placeholder')"/>
          </div>

          <div class="padding-bottom text-align-left">
            <label for="firstName">{{ $t("user.firstName") }}</label>
            <input class="full-width" id="firstName" type="text" v-model="user.firstName" required :placeholder="$t('auth.email-placeholder')"/>
          </div>

          <div class="padding-bottom text-align-left">
            <label for="lastName">{{ $t("user.lastName") }}</label>
            <input class="full-width" id="lastName" type="text" v-model="user.lastName" required :placeholder="$t('auth.email-placeholder')"/>
          </div>

          <div class="padding-bottom text-align-left">
            <label for="lastName">{{ $t("user.role") }}</label>
            <select class="full-width" id="role" v-model="user.role">
              <option value="admin"> {{ $t("role.admin")}} </option>
              <option value="member"> {{ $t("role.member")}} </option>
            </select>
          </div>
          <button type="submit" class="padding full-width">Mettre à jour</button>
        </form>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>