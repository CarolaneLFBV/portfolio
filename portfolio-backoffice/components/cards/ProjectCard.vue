<script setup lang="ts">
import {ref} from "vue";
import {useRouter} from "#vue-router";
import type {Project} from "~/types/project";
import useProjects from "~/composables/useProjects";
import useSkills from "~/composables/useSkills";
import type {Skill} from "~/types/skill";
import type {Experience} from "~/types/experience";
import DeleteButton from "~/components/buttons/DeleteButton.vue";
import BaseButton from "~/components/buttons/BaseButton.vue";

const { getProjects, deleteProject } = useProjects()
const { getExperiences } = useExperiences()
const { getSkills } = useSkills();
const router = useRouter();
const projects = ref<Project[]>([]);
const skills = ref<Skill[]>([]);
const experiences = ref<Experience[]>([]);
const skillsMap = ref({});
const experiencesMap = ref({});

onMounted(async () => {
  await onInit();
})

async function onInit() {
  try {
    projects.value = await getProjects();
    skills.value = await getSkills();
    experiences.value = await getExperiences();
    skillsMap.value = Object.fromEntries(skills.value.map(skill => [skill.id, skill]));
    experiencesMap.value = Object.fromEntries(experiences.value.map(experience => [experience.id, experience]));
  } catch (error) {
    console.error(error);
  }
}

function onEdit(id: string) {
  router.push(`/projects/${id}`);
}

async function onDelete(id: string) {
  try {
    await deleteProject(id);
    projects.value = await getProjects();
  } catch (error) {
    console.error(error);
  }
}
</script>

<template>
  <div v-if="projects" class="flex flex-row flex-wrap">
    <div v-for="project in projects" :key="project.id" class="card-container text-white">
      <div class="flex flex-row mb-2">
        <h3 class="text-violet font-semibold text-xl"> {{ project.name }} </h3>
      </div>

      <div class="flex flex-col mb-2">
        <label class="mr-1 font-semibold">{{ $t("skills.title")}}</label>
        <div class="flex flex-wrap gap-2">
          <div v-for="skillId in project.skills" :key="skillId">
            <p class="w-fit mt-0.5 text-sm bg-violet-dark p-1 rounded" v-if="skillsMap[skillId]">{{ skillsMap[skillId].name }}</p>
          </div>
        </div>
      </div>

      <div class="flex flex-col mb-2">
        <label class="mr-1 font-semibold">{{ $t("experiences.title")}}</label>
        <div class="flex flex-wrap gap-2">
          <div v-for="expId in project.experiences" :key="expId">
            <p class="w-fit mt-0.5 text-sm bg-violet-dark p-1 rounded" v-if="experiencesMap[expId]">{{ experiencesMap[expId].name }}</p>
          </div>
        </div>
      </div>

      <div class="text-right">
        <BaseButton class="bg-violet hover:bg-violet-dark" @click="onEdit(project.id)">{{ $t("utils.edit") }} </BaseButton>
        <DeleteButton @click="onDelete(project.id)">{{ $t("utils.delete") }} </DeleteButton>
      </div>
    </div>
  </div>
</template>
