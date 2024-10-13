<script setup lang="ts">
import {definePageMeta} from "#imports";
import SkillCard from "~/components/cards/SkillCard.vue";
import BaseButton from "~/components/buttons/BaseButton.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

function createProject() {
  navigateTo("/skills/create");
}

</script>

<template>
  <main>
    <div class="mb-4">
      <h1>{{ $t("skills.title") }}</h1>
        <BaseButton class="bg-pink hover:bg-pink-dark" @click="createProject">{{ $t("utils.create") }}</BaseButton>
    </div>
    <SkillCard />
  </main>
</template>

<style scoped>
</style>