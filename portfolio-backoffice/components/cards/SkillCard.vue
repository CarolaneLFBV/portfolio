<script setup lang="ts">
import {ref} from "vue";
import type {Skill} from "~/types/skill";
import useSkills from "~/composables/useSkills";
import {useRouter} from "#vue-router";
import useProjects from "~/composables/useProjects";
import type {Project} from "~/types/project";
import BaseButton from "~/components/buttons/BaseButton.vue";
import DeleteButton from "~/components/buttons/DeleteButton.vue";

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

function onEdit(id: string) {
  router.push(`/skills/${id}`);
}

async function onDelete(id: string) {
  try {
    await deleteSkill(id);
    skills.value = await getSkills();
  } catch (error) {
    console.error(error);
  }
}

</script>

<template>
  <div v-if="skills" class="flex flex-row flex-wrap">
    <div v-for="skill in skills" :key="skill.id" class="card-container text-white">
      <div class="flex flex-row mb-2">
        <h3 class="text-violet font-semibold text-xl"> {{ skill.name }} </h3>
      </div>

      <div class="flex flex-row mb-2">
        <div v-for="tag in skill.tags" :key="skillId" class="items-center">
          <p class="text-sm bg-violet p-1 mr-1 rounded" > {{ tag }} </p>
        </div>
      </div>

      <div class="text-right">
        <BaseButton @click="onEdit(skill.id)">{{ $t("utils.edit") }}</BaseButton>
        <DeleteButton @click="onDelete(skill.id)">{{ $t("utils.delete") }}</DeleteButton>
      </div>

    </div>
  </div>
</template>

<style scoped>

</style>