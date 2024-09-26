<script setup lang="ts">
import {useAuthStore} from "~/stores/useAuthStore";
import useUsers from "~/composables/useUsers";
import {useRouter} from "#vue-router";

const {authenticateUser} = useAuthStore()
const {user} = useUsers();
const router = useRouter();

async function onLogin() {
  try {
    await authenticateUser({email: user.value.email, password: user.value.password})
    await router.push("/dashboard");
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
        <h2> {{ $t("login.title") }}</h2>
      </div>
      <form @submit.prevent="onLogin">
        <div class="padding-bottom text-align-left">
          <label for="email">{{ $t("email") }}</label>
          <input class="full-width" id="email" type="email" v-model="user.email" required :placeholder="$t('login.email-placeholder')"/>
        </div>

        <div class="padding-bottom margin-bottom text-align-left">
          <label for="password">{{ $t("password") }}</label>
          <input class="full-width" id="password" type="password" v-model="user.password" required :placeholder="$t('login.password-placeholder')"/>
        </div>

        <button type="submit" class="padding full-width">{{ $t("login.login") }}</button>
      </form>
    </div>
  </div>
</template>

<style scoped lang="scss">



input {
  padding: .75rem;
  background-color: var(--background-color);
  border: none;
  border-radius: .5rem;
  font-size: 1rem;
  color: var(--text-color);
}

label {
  font-size: 1rem;
  color: var(--caption-color);
  display: block;
  margin-bottom: .5rem;
}
</style>
