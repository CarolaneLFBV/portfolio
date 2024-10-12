<script setup lang="ts">
import {useRoute} from "#vue-router";
import {ref} from "vue";
import type {Skill} from "~/types/skill";
import type {Project} from "~/types/project";
import useProjects from "~/composables/useProjects";
import useSkills from "~/composables/useSkills";
import BaseButton from "~/components/buttons/BaseButton.vue";

const route = useRoute();
const { getProjectById, updateProject } = useProjects();
const { getSkills } = useSkills();
const project = ref<Project>(null);
const skills = ref<Skill[]>([]);
const selectedSkillIDs = ref<Skill[]>([]);

onMounted(async () => {
  await onInit();
})

async function onInit() {
  const projectId = route.params.id;
  try {
    project.value = await getProjectById(projectId);
    skills.value = await getSkills();
    selectedSkillIDs.value = project.value.skills || [];
  } catch (error) {
    console.error(error);
  }
}

async function onUpdate() {
  try {
    project.value.skills = selectedSkillIDs.value;
    await updateProject(project.value);
    navigateTo('/projects');
  } catch (error) {
    console.error(error);
  }
}
</script>


<template>
  <div v-if="project">
    <div class="flex flex-col">
      <div class="card-container items-center">
        <h1 class="text-center">{{ $t("utils.edit") }} {{ project.title }}</h1>
        <form @submit.prevent="onUpdate" class="text-left">
          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="title">{{ $t("projects.name") }}</label>
            <input class="form-input rounded-lg" v-model="project.title" id="title" type="text" required />
          </div>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="presentation">{{ $t("projects.intro") }}</label>
            <textarea class="form-input rounded-lg" v-model="project.presentation" id="presentation"></textarea>
          </div>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="purpose">{{ $t("projects.goal") }}</label>
            <textarea class="form-input rounded-lg" v-model="project.purpose" id="purpose"></textarea>
          </div>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="milestone">{{ $t("projects.milestones") }}</label>
            <textarea class="form-input rounded-lg" v-model="project.milestone" id="milestone"></textarea>
          </div>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="actor">{{ $t("projects.actors") }}</label>
            <input class="form-input rounded-lg" v-model="project.actor" id="actor" type="text" />
          </div>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="progress">{{ $t("projects.progress") }}</label>
            <input class="form-input rounded-lg" v-model="project.progress" id="progress" type="text" />
          </div>

          <fieldset class="flex flex-row justify-around border rounded mb-2">
            <legend class="p-0.5 ml-2">{{ $t("skills.title") }}</legend>
            <div class="grid grid-cols-2 gap-4 mb-2 ">
              <div v-for="skill in skills" :key="skill.id" class="flex flex-row items-center">
                <input type="checkbox" class="rounded text-violet" :value="skill.id" v-model="selectedSkillIDs" />
                <p class="ml-1">{{ skill.name }}</p>
              </div>
            </div>
          </fieldset>

          <div class="text-center">
            <BaseButton type="submit" class="w-full"> {{ $t("utils.update") }} </BaseButton>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
