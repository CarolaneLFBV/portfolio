<script setup lang="ts">
import {useAuthStore} from "~/stores/useAuthStore";
import useUsers from "~/composables/useUsers";
import {useRouter} from "#vue-router";
import BaseButton from "~/components/buttons/BaseButton.vue";

const {authenticateUser} = useAuthStore()
const {user} = useUsers();
const router = useRouter();

async function onLogin() {
  try {
    await authenticateUser({email: user.value.email, password: user.value.password})
    await navigateTo("/dashboard");
  } catch (error) {
    console.log(error);
  }
}
</script>

<template>
  <div class="flex items-center justify-center h-screen">
    <div class="card-container">
      <div>
        <img src="public/okeep.png" alt="User Profile" class="rounded-full mx-auto mb-2 size-32"/>
        <h1 class="flex justify-center text-2xl mb-4 text-white"> {{ $t("auth.login-title") }}</h1>
      </div>
      <form @submit.prevent="onLogin">
        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="email">{{ $t("auth.email") }}</label>
          <input id="email" type="email" v-model="user.email" required :placeholder="$t('auth.email-placeholder')" class="form-input rounded-lg"/>
        </div>

        <div class="flex flex-col mb-4">
          <label class="text-white opacity-50 text-sm mb-1" for="password">{{ $t("auth.password") }}</label>
          <input id="password" type="password" v-model="user.password" required :placeholder="$t('auth.password-placeholder')" class="form-input rounded-lg"/>
        </div>

        <BaseButton type="submit"> {{ $t("auth.login") }} </BaseButton>
      </form>
    </div>
  </div>
</template>