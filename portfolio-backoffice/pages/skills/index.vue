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
    <h2>{{ $t("skills.title") }}</h2>
    <SkillCard />
    <div class="margin">
      <NuxtLink class="link-btn" to="/skills/create">{{ $t("utils.create") }}</NuxtLink>
    </div>
  </main>
</template>

<style scoped>
</style>