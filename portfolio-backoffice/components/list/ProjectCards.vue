<script lang="ts" setup>
import {computed, onMounted, ref} from "vue";
import useProject from "~/composables/useProject";
import NoDataView from "~/components/dashboard/NoDataView.vue";
import type {Project} from "~/types/project";
import ProjectCard from "~/components/card/ProjectCard.vue";

const props = defineProps<{
  type: "technical" | "soft";
}>();

const projects = ref<Project[]>([]);
const {getProjects} = useProject();
const filteredProjects = computed(() => {
  return projects.value.filter(project => project.type === props.type);
});

const loadData = async () => {
  try {
    projects.value = await getProjects();
  } catch (error) {
    console.error(error);
  }
}

onMounted(async () => {
  await loadData();
});

const removeSkill = (slug: string) => {
  projects.value = projects.value.filter(project => project.slug !== slug);
};
</script>

<template>
  <ProjectCard
      v-for="project in filteredProjects"
      v-if="filteredProjects.length"
      :skill="project"
      @skillDeleted="removeSkill"
  />
  <div v-if="!filteredProjects.length">
    <NoDataView/>
  </div>
</template>