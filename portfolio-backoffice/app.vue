<script setup lang="ts">
import LayoutFooter from "~/layouts/LayoutFooter.vue";
</script>

<template>
  <main class="h-screen flex flex-col">
    <NuxtLayout>
      <NuxtPage />
      <LayoutFooter/>
    </NuxtLayout>
  </main>
</template>

<style scoped>
</style>