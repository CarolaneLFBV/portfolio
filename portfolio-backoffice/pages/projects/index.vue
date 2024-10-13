<script setup lang="ts">
import {definePageMeta} from "#imports";
import ProjectCard from "~/components/cards/ProjectCard.vue";
import BaseButton from "~/components/buttons/BaseButton.vue";

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
    <div class="mb-4">
      <h1>{{ $t("projects.title") }}</h1>
      <BaseButton class="bg-violet hover:bg-violet-dark" @click="createProject">
        {{ $t("utils.create") }}
      </BaseButton>
    </div>
    <ProjectCard />
  </main>
</template>
