<script setup lang="ts">
import {definePageMeta} from "#imports";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})
</script>

<template>
  <div>
    <h2>{{ $t("experiences.title") }}</h2>
  </div>
</template>

<style scoped>

</style>