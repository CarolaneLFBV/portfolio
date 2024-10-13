<script setup lang="ts">
import {ref} from "vue";
import {useRoute} from "#vue-router";
import type {Skill} from "~/types/skill";
import useSkills from "~/composables/useSkills";
import useProjects from "~/composables/useProjects";
import type {Project} from "~/types/project";
import BaseButton from "~/components/buttons/BaseButton.vue";
import CancelButton from "~/components/buttons/CancelButton.vue";

const { getSkillById, updateSkill } = useSkills();
const { getProjects } = useProjects();
const skill = ref<Skill | null>(null);
const projects = ref<Project[]>([]);
const selectedProjectsIDs = ref<Project[]>([]);
const route = useRoute();

onMounted(async () => {
  await onInit();
});

async function onInit() {
  const skillId = route.params.id;
  try {
    skill.value = await getSkillById(skillId);
    projects.value = await getProjects();
    selectedProjectsIDs.value = skill.value.projects || [];
  } catch (error) {
    console.error("Erreur lors de la récupération du skill :", error);
  }
}

async function onUpdate() {
  try {
    skill.value.tags = skill.value.tags.split(',').map(tag => tag.trim());
    skill.value.projects = selectedProjectsIDs.value;
    await updateSkill(skill.value);
  } catch (error) {
    console.error(error);
  }
}
</script>

<template>
  <div v-if="skill">
    <div class="flex flex-col">
      <div class="card-container items-center">
          <h1 class="text-center">{{ $t("utils.edit") }} {{ skill.name }}</h1>
          <form @submit.prevent="onUpdate" class="text-left">
            <div class="flex flex-col mb-2">
              <label class="text-white text-opacity-50 text-sm mb-1"  for="name">Name</label>
              <input v-model="skill.name" id="name" type="text" required />
            </div>

            <div class="flex flex-col mb-2">
              <label class="text-white text-opacity-50 text-sm mb-1"  for="tags">Tags (comma-separated)</label>
              <input
                  v-model="skill.tags"
                  id="tags"
                  type="text"
                  class="form-input rounded-lg"
                  placeholder="e.g. JavaScript, Web Development"
                  required
              />
            </div>

            <div class="flex flex-col mb-2">
              <label class="text-white text-opacity-50 text-sm mb-1"  for="context">Context</label>
              <textarea class="form-input rounded-lg" v-model="skill.context" id="context" required></textarea>
            </div>

            <div class="flex flex-col mb-2">
              <label class="text-white text-opacity-50 text-sm mb-1"  for="proofs">Proofs</label>
              <textarea class="form-input rounded-lg" v-model="skill.proofs" id="proofs" required></textarea>
            </div>

            <div class="flex flex-col mb-2">
              <label class="text-white text-opacity-50 text-sm mb-1"  for="retrospective">Retrospective</label>
              <textarea class="form-input rounded-lg" v-model="skill.retrospective" id="retrospective" required></textarea>
            </div>

            <div class="flex flex-col mb-2">
              <label class="text-white text-opacity-50 text-sm mb-1"  for="progress">Progress</label>
              <textarea class="form-input rounded-lg" v-model="skill.progress" id="progress" required></textarea>
            </div>

            <fieldset class="flex flex-row justify-around border rounded mb-2">
              <legend class="p-0.5 ml-2">{{ $t("projects.title") }}</legend>
              <div class="grid grid-cols-2 gap-4 mb-2 ">
                <div v-for="project in projects" :key="project.id" class="flex flex-row items-center">
                  <input type="checkbox" class="rounded text-violet" :value="project.id" v-model="selectedProjectIDs" />
                  <p class="ml-1">{{ project.name }}</p>
                </div>
              </div>
            </fieldset>

            <div class="text-center">
              <BaseButton type="submit"> {{ $t("utils.update") }} </BaseButton>
              <CancelButton/>
            </div>
          </form>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>