<script setup lang="ts">
import {definePageMeta} from "#imports";
import BaseButton from "~/components/buttons/BaseButton.vue";
import ExperienceCard from "~/components/cards/ExperienceCard.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

function createExperience() {
  navigateTo("/experiences/create");
}
</script>

<template>
  <main>
    <div class="mb-4">
      <h1>{{ $t("experiences.title") }}</h1>
      <BaseButton @click="createExperience">
        {{ $t("utils.create") }}
      </BaseButton>
    </div>
    <ExperienceCard />
  </main>
</template>

<style scoped>

</style>