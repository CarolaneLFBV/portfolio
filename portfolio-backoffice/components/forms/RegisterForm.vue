<script setup lang="ts">
import {useAuthStore} from "~/stores/useAuthStore";
import useUsers from "~/composables/useUsers";

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
  <div class="full-height flex-column text-align-center">
    <div class="card-container">
      <div class="text-align-center">
        <img src="public/okeep.png" alt="User Profile" class="profile-image margin-bottom"/>
        <h2> {{ $t("auth.signup-title") }}</h2>
      </div>
      <form @submit.prevent="onRegister">
        <div class="padding-bottom text-align-left">
          <label for="email">{{ $t("auth.email") }}</label>
          <input class="full-width" id="email" type="email" v-model="user.email" required :placeholder="$t('auth.email-placeholder')"/>
        </div>

        <div class="padding-bottom margin-bottom text-align-left">
          <label for="password">{{ $t("auth.password") }}</label>
          <input class="full-width" id="password" type="password" v-model="user.password" required :placeholder="$t('auth.password-placeholder')"/>
        </div>

        <button type="submit">{{ $t("auth.signup") }}</button>

      </form>
    </div>
  </div>
</template>

<style scoped>
button, .link-btn {
  width: 100%;
}
</style>