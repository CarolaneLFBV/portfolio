<script setup lang="ts">
import {useRoute} from "#vue-router";
import {ref} from "vue";
import type {Skill} from "~/types/skill";
import type {Project} from "~/types/project";
//import type {Experience} from "~/types/experience";
import useProjects from "~/composables/useProjects";
import useSkills from "~/composables/useSkills";
import BaseButton from "~/components/buttons/BaseButton.vue";
import CancelButton from "~/components/buttons/CancelButton.vue";

const route = useRoute();
const { getProjectById, updateProject } = useProjects();
const { getSkills } = useSkills();
const { getExperiences } = useExperiences();
const project = ref<Project>(null);
const skills = ref<Skill[]>([]);
const experiences = ref<Experience[]>([]);
const selectedSkillIDs = ref<Skill[]>([]);
const selectedExperienceIDs = ref<Experience[]>([]);

onMounted(async () => {
  await onInit();
})

async function onInit() {
  const projectId = route.params.id;
  try {
    project.value = await getProjectById(projectId);
    skills.value = await getSkills();
    experiences.value = await getExperiences();
    selectedSkillIDs.value = project.value.skills || [];
    selectedExperienceIDs.value = project.value.experiences || [];
  } catch (error) {
    console.error(error);
  }
}

async function onUpdate() {
  try {
    project.value.skills = selectedSkillIDs.value;
    project.value.experiences = selectedExperienceIDs.value;
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
        <h1 class="text-center">{{ $t("utils.edit") }} {{ project.name }}</h1>
        <form @submit.prevent="onUpdate" class="text-left">
          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="title">{{ $t("projects.name") }}</label>
            <input class="form-input rounded-lg" v-model="project.name" id="title" type="text" required />
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

          <fieldset v-if="skills.length > 0" class="flex flex-row justify-around border rounded mb-2">
            <legend class="p-0.5 ml-2">{{ $t("skills.title") }}</legend>
            <div class="grid grid-cols-2 gap-4 mb-2 ">
              <div v-for="skill in skills" :key="skill.id" class="flex flex-row items-center">
                <input type="checkbox" class="rounded text-violet" :value="skill.id" v-model="selectedSkillIDs" />
                <p class="ml-1">{{ skill.name }}</p>
              </div>
            </div>
          </fieldset>

          <fieldset v-if="experiences.length > 0" class="flex flex-row justify-around border rounded mb-2">
            <legend class="p-0.5 ml-2">{{ $t("experiences.title") }}</legend>
            <div class="grid grid-cols-2 gap-4 mb-2 ">
              <div v-for="exp in experiences" :key="exp.id" class="flex flex-row items-center">
                <input type="checkbox" class="rounded text-violet" :value="exp.id" v-model="selectedExperienceIDs" />
                <p class="ml-1">{{ exp.name }}</p>
              </div>
            </div>
          </fieldset>

          <div class="text-center">
            <BaseButton class="bg-violet hover:bg-violet-dark" type="submit"> {{ $t("utils.update") }} </BaseButton>
            <CancelButton/>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>
