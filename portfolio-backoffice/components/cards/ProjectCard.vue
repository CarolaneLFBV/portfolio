<script setup lang="ts">
import {ref} from "vue";
import {useRouter} from "#vue-router";
import type {Project} from "~/types/project";
import useProjects from "~/composables/useProjects";
import useSkills from "~/composables/useSkills";
import type {Skill} from "~/types/skill";

const { getProjects, deleteProject } = useProjects()
const { getSkills } = useSkills();
const router = useRouter();
const projects = ref<Project[]>([]);
const skills = ref<Skill[]>([]);
const skillsMap = ref({});

onMounted(async () => {
  await onInit();
})

async function onInit() {
  try {
    projects.value = await getProjects();
    skills.value = await getSkills();
    // Map skills with ids in project.skills
    skillsMap.value = Object.fromEntries(skills.value.map(skill => [skill.id, skill]));
  } catch (error) {
    console.error(error);
  }
}

function edit(id: string) {
  router.push(`/projects/${id}`);
}

async function deleteID(id: string) {
  try {
    await deleteProject(id);
    projects.value = await getProjects();
  } catch (error) {
    console.error(error);
  }
}
</script>

<template>
  <div v-if="projects" class="flex-row flex-wrap">
    <div v-for="project in projects" :key="project.id" class="card-container margin text-align-left">
      <p><strong>{{ $t("projects.unique") }}:</strong> {{ project.title }} </p>
      <div class="flex-row">
        <strong>{{ $t("skills.title") }}:</strong>
        <div v-for="skillId in project.skills" :key="skillId">
          <p v-if="skillsMap[skillId]">{{skillsMap[skillId].name}}</p>
        </div>
      </div>
      <div class="text-align-right">
        <button class="margin-right" @click="edit(project.id)">
          <span class="material-icons">edit</span>
          {{ $t("utils.edit") }}
        </button>
        <button @click="deleteID(project.id)">
          <span class="material-icons">delete</span>
          {{ $t("utils.delete") }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>