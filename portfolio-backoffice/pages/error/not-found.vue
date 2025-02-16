<script setup>
import {useI18n} from "#imports";

const {t} = useI18n();
</script>

<template>
  <div class="flex flex-col items-center justify-center min-h-screen text-center space-y-6">
    <h1 class="text-6xl font-bold">{{ t("errors.not-found.code") }}</h1>
    <p class="text-xl">{{ t("errors.not-found.message") }}</p>
    <NuxtLink to="/dashboard">
      <Button>{{ t("errors.go-back") }}</Button>
    </NuxtLink>
  </div>
</template>

<style scoped>
</style>