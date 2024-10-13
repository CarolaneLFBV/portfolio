<script setup lang="ts">
import BaseButton from "~/components/buttons/BaseButton.vue";

function navigateLogin() {
  navigateTo("/");
}

</script>

<template>
  <div class="flex items-center justify-center h-screen">
    <div class="card-container">
      <div>
        <img src="public/okeep.png" alt="User Profile" class="rounded-full mx-auto mb-2 size-32"/>
        <h1 class="flex justify-center text-2xl mb-4 text-white">{{ $t("errors.not-found") }}</h1>
        <h2 class="flex justify-center mb-4">{{ $t("errors.not-found-desc") }}</h2>
        <div class="text-center">
          <BaseButton @click="navigateLogin">{{ $t("errors.back-to-login") }}</BaseButton>
        </div>
      </div>
    </div>
  </div>
</template>