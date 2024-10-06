<script setup lang="ts">
import {definePageMeta} from "#imports";
import ProjectCard from "~/components/cards/ProjectCard.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

</script>

<template>
  <main>
    <div class="flex-space-between">
      <h2>{{ $t("projects.title") }}</h2>
      <NuxtLink class="link-btn" to="/projects/create">{{ $t("utils.create") }}</NuxtLink>
    </div>
    <ProjectCard />
  </main>
</template>

<style scoped>
</style>