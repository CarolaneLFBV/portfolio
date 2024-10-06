<script setup lang="ts">
import {definePageMeta} from "#imports";
import SkillCard from "~/components/cards/SkillCard.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

</script>

<template>
  <main>
    <div class="flex-space-between">
      <h2>{{ $t("skills.title") }}</h2>
      <NuxtLink class="link-btn" to="/skills/create">{{ $t("utils.create") }}</NuxtLink>
    </div>
    <SkillCard />
  </main>
</template>

<style scoped>
</style>