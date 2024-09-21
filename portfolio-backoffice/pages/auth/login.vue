<script lang="ts" setup>
import { useAuthStore } from '~/stores/useAuthStore'
import useSecurity from "~/composables/useSecurity";
import { useRouter } from 'vue-router';

const {authenticateUser} = useAuthStore()
const {user} = useSecurity();
const router = useRouter();

async function onLogin() {
  try {
    await authenticateUser({email: user.value.email, password: user.value.password})
    await router.push('/dashboard')
  } catch (error) {
    console.log(error);
  }
}

</script>


<template>
  <div class="login-container">
    <h1>Login</h1>
    <form @submit.prevent="onLogin">
      <div>
        <label for="email">Email</label>
        <input v-model="user.email" id="email" type="email" required />
      </div>
      <div>
        <label for="password">Password</label>
        <input v-model="user.password" id="password" type="password" required />
      </div>
      <div>
        <button type="submit">Login</button>
      </div>
    </form>
  </div>
</template>

<style scoped>
/* Style basique pour le formulaire */
.login-container {
  max-width: 400px;
  margin: 0 auto;
  padding: 2rem;
  background-color: #f9f9f9;
  border-radius: 8px;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}
</style>
