<script setup lang="ts">
import {ref} from "vue";
import type {Skill} from "~/types/skill";
import useSkills from "~/composables/useSkills";
import {useRouter} from "#vue-router";
import useProjects from "~/composables/useProjects";
import type {Project} from "~/types/project";

const skills = ref<Skill[]>([]);
const { getSkills, deleteSkill } = useSkills()
const { getProjects } = useProjects()
const router = useRouter();
const projects = ref<Project[]>([]);
const projectsMap = ref({});

onMounted(async () => {
  await onInit();
})

async function onInit() {
  try {
    projects.value = await getProjects();
    skills.value = await getSkills();
    // Map skills with ids in project.skills
    projectsMap.value = Object.fromEntries(projects.value.map(project => [project.id, project]));
  } catch (error) {
    console.error(error);
  }
}

function edit(id: string) {
  router.push(`/skills/${id}`);
}

async function deleteID(id: string) {
  try {
    await deleteSkill(id);
  } catch (error) {
    console.error(error);
  }
}

</script>

<template>
  <div v-if="skills" class="flex-row flex-wrap">
    <div v-for="skill in skills" :key="skill.id" class="card-container margin text-align-left">
      <p><strong>{{ $t("skills.unique") }}:</strong> {{ skill.name }} </p>
      <div class="flex-row flex-wrap">
        <p v-for="tag in skill.tags"> {{ tag }} </p>
      </div>
      <div class="text-align-right">
        <button class="margin-right" @click="edit(skill.id)">
          <span class="material-icons">edit</span>
          {{ $t("utils.edit") }}
        </button>
        <button @click="deleteID(skill.id)">
          <span class="material-icons">delete</span>
          {{ $t("utils.delete") }}
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>