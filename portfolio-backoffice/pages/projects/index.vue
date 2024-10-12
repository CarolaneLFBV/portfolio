<script setup lang="ts">
import {definePageMeta} from "#imports";
import ProjectCard from "~/components/cards/ProjectCard.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

function createProject() {
   navigateTo("/projects/create");
}

</script>

<template>
  <main>
    <h1>{{ $t("projects.title") }}</h1>
    <BaseButton @click="createProject">
      {{ $t("utils.create") }}
    </BaseButton>
    <ProjectCard />
  </main>
</template>
