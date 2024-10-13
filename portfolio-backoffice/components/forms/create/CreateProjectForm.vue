<script setup lang="ts">

import useProjects from "~/composables/useProjects";
import useSkills from "~/composables/useSkills";
import {ref} from "vue";
import type {Skill} from "~/types/skill";
import BaseButton from "~/components/buttons/BaseButton.vue";
import CancelButton from "~/components/buttons/CancelButton.vue";
import type {Experience} from "~/types/experience";

const { createProject, newProject } = useProjects();
const { getSkills } = useSkills();
const skills = ref<Skill[]>([]);
const experiences = ref<Experience[]>([]);
const selectedSkillIDs = ref([]);
const selectedExperienceIDs = ref([]);

onMounted(async () => {
  await onInit();
})

async function onInit() {
  try {
    skills.value = await getSkills();
  } catch (error) {
    console.error(error);
  }
}

async function onCreate() {
  try {
    newProject.value.skills = selectedSkillIDs.value;
    newProject.value.experiences = selectedExperienceIDs.value;
    await createProject(newProject.value);
    await navigateTo("/projects");
  } catch (error) {
    console.error("Error creating skill:", error);
  }
}
</script>

<template>
  <div class="flex flex-col">
    <div class="card-container items-center">
      <h1 class="text-center">{{ $t("projects.new") }}</h1>
      <form @submit.prevent="onCreate" class="text-left">
        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="title">{{ $t("projects.name") }}</label>
          <input class="form-input rounded-lg" v-model="newProject.name" id="title" type="text" required />
        </div>

        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="presentation">{{ $t("projects.intro") }}</label>
          <textarea class="form-input rounded-lg" v-model="newProject.presentation" id="presentation"></textarea>
        </div>

        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="purpose">{{ $t("projects.goal") }}</label>
          <textarea class="form-input rounded-lg" v-model="newProject.purpose" id="purpose"></textarea>
        </div>

        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="milestone">{{ $t("projects.milestones") }}</label>
          <textarea class="form-input rounded-lg" v-model="newProject.milestone" id="milestone"></textarea>
        </div>

        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="actor">{{ $t("projects.actors") }}</label>
          <textarea class="form-input rounded-lg" v-model="newProject.actor" id="actor" type="text" />
        </div>

        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="progress">{{ $t("projects.progress") }}</label>
          <textarea class="form-input rounded-lg" v-model="newProject.progress" id="progress" type="text" />
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
          <legend class="p-0.5 ml-2">{{ $t("skills.title") }}</legend>
          <div class="grid grid-cols-2 gap-4 mb-2 ">
            <div v-for="exp in experiences" :key="exp.id" class="flex flex-row items-center">
              <input type="checkbox" class="rounded text-violet" :value="exp.id" v-model="selectedExperienceIDs" />
              <p class="ml-1">{{ exp.name }}</p>
            </div>
          </div>
        </fieldset>

        <div class="text-center">
          <BaseButton type="submit"> {{ $t("utils.create") }} </BaseButton>
          <CancelButton/>
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>

</style>