<script setup lang="ts">
import {definePageMeta} from "#imports";
import {ref} from "vue";
import type {Project} from "~/types/project";
import {useRouter} from "#vue-router";
import useProjects from "~/composables/useProjects";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

const { getProjects } = useProjects()
const router = useRouter();
const projects = ref<Project[]>([]);

onMounted(async () => {
  await onInit();
})

async function onInit() {
  try {
    projects.value = await getProjects();
  } catch (error) {
    console.error(error);
  }
}
</script>

<template>
  <h1>{{ $t("dashboard.title") }}</h1>
  <h2>PROJECTS</h2>
  <div v-for="project in projects" :key="project.id" class="card-container margin text-align-left">
    <p><strong>{{ $t("project.title") }}:</strong> {{ project.title }} </p>
  </div>
  <button>Add Project</button>
</template>

<style scoped>

</style>