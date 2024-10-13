<script setup lang="ts">
import {useAuthStore} from "~/stores/useAuthStore";
import useUsers from "~/composables/useUsers";
import BaseButton from "~/components/buttons/BaseButton.vue";

const {register} = useAuthStore();
const {user} = useUsers();

async function onRegister() {
  try {
    await register({
      email: user.value.email,
      password: user.value.password,
      role: 'member',
    })
  } catch (error) {
    console.log(error);
  }
}
</script>

<template>
  <div class="flex items-center justify-center">
    <div class="card-container">
      <div class="text-align-center">
        <h1 class="flex justify-center text-2xl mb-4 text-white"> {{ $t("auth.signup-title") }}</h1>
      </div>
      <form @submit.prevent="onRegister">
        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="email">{{ $t("auth.email") }}</label>
          <input class="form-input rounded-lg" id="email" type="email" v-model="user.email" required :placeholder="$t('auth.email-placeholder')"/>
        </div>

        <div class="flex flex-col mb-4">
          <label class="text-white text-opacity-50 text-sm mb-1" for="password">{{ $t("auth.password") }}</label>
          <input class="form-input rounded-lg" id="password" type="password" v-model="user.password" required :placeholder="$t('auth.password-placeholder')"/>
        </div>

        <div class="text-center">
          <BaseButton class="bg-violet hover:bg-violet-dark" type="submit"> {{ $t("auth.signup") }} </BaseButton>
        </div>
      </form>
    </div>
  </div>
</template>