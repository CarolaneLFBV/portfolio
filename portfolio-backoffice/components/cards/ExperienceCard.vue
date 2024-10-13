<script setup lang="ts">
import {useRouter} from "#vue-router";
import useExperiences from "~/composables/useExperiences";
import useSkills from "~/composables/useSkills";
import useProjects from "~/composables/useProjects";
import {ref} from "vue";
import type {Project} from "~/types/project";
import type {Skill} from "~/types/skill";
import type {Experience} from "~/types/experience";
import DeleteButton from "~/components/buttons/DeleteButton.vue";
import BaseButton from "~/components/buttons/BaseButton.vue";

const router = useRouter()
const { getExperiences, deleteExperience } = useExperiences();
const { getSkills } = useSkills();
const { getProjects } = useProjects();
const projects = ref<Project[]>([]);
const skills = ref<Skill[]>([]);
const experiences = ref<Experience[]>([]);
const skillsMap = ref({});
const projectsMap = ref({});

onMounted(async () => {
  await onInit();
})

async function onInit() {
  try {
    experiences.value = await getExperiences();
    projects.value = await getProjects();
    skills.value = await getSkills();
    skillsMap.value = Object.fromEntries(skills.value.map(skill => [skill.id, skill]));
    projectsMap.value = Object.fromEntries(projects.value.map(project => [project.id, project]));
  } catch (error) {
    console.error(error);
  }
}

function onEdit(id: string) {
  router.push(`/experiences/${id}`);
}

async function onDelete(id: string) {
  try {
    await deleteExperience(id);
    projects.value = await getProjects();
  } catch (error) {
    console.error(error);
  }
}

</script>

<template>
  <div v-if="experiences" class="flex flex-row flex-wrap">
    <div v-for="exp in experiences" :key="exp.id" class="card-container text-white">
      <div class="flex flex-row mb-2">
        <h3 class="text-indigo font-semibold text-xl"> {{ exp.name }} </h3>
      </div>

      <div class="flex flex-col mb-2">
        <label class="mr-1 font-semibold">{{ $t("skills.title")}}</label>
        <div class="flex flex-wrap gap-2">
          <div v-for="skillId in exp.skills" :key="skillId">
            <p class="w-fit mt-0.5 text-sm bg-indigo-dark p-1 rounded" v-if="skillsMap[skillId]">{{ skillsMap[skillId].name }}</p>
          </div>
        </div>
      </div>

      <div class="flex flex-col mb-2">
        <label class="mr-1 font-semibold">{{ $t("projects.title")}}</label>
        <div class="flex flex-wrap gap-2">
          <div v-for="projectId in exp.projects" :key="projectId">
            <p class="w-fit mt-0.5 text-sm bg-indigo-dark p-1 rounded" v-if="projectsMap[projectId]">{{ projectsMap[projectId].name }}</p>
          </div>
        </div>
      </div>

      <div class="text-right">
        <BaseButton class="bg-indigo hover:bg-indigo-dark" @click="onEdit(exp.id)">{{ $t("utils.edit") }} </BaseButton>
        <DeleteButton @click="onDelete(exp.id)">{{ $t("utils.delete") }} </DeleteButton>
      </div>

    </div>
  </div>
</template>

<style scoped>

</style>