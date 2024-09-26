<script setup lang="ts">
import {definePageMeta} from "#imports";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})
</script>

<template>
  <h1>{{ $t("dashboard.title") }}</h1>
  <div>
    <h2>EXPERIENCES</h2>
  </div>
</template>

<style scoped>

</style>