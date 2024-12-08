<script setup lang="ts">

import useProjects from "~/composables/useProjects";
import useSkills from "~/composables/useSkills";
import {ref} from "vue";
import type {Skill} from "~/types/skill";
import BaseButton from "~/components/buttons/BaseButton.vue";
import CancelButton from "~/components/buttons/CancelButton.vue";
import type { Project } from "~/types/project";

const { createExperience, newExperience } = useExperiences();
const { getSkills } = useSkills();
const { getProjects } = useProjects();
const skills = ref<Skill[]>([]);
const projects = ref<Project[]>([]);
const selectedSkillIDs = ref([]);
const selectedProjectIDs = ref([]);
const selectedType = ref<string>(newExperience.type);

onMounted(async () => {
  await onInit();
})

async function onInit() {
  try {
    skills.value = await getSkills();
    projects.value = await getProjects();
  } catch (error) {
    console.error(error);
  }
}

async function onCreate() {
  try {
    newExperience.value.skills = selectedSkillIDs.value;
    newExperience.value.skills = selectedProjectIDs.value;
    newExperience.value.type = selectedType.value;
    await createExperience(newExperience.value);
    await navigateTo("/projects");
  } catch (error) {
    console.error("Error creating skill:", error);
  }
}
</script>

<template>
  <div class="flex flex-col">
    <div class="card-container items-center">
      <h1 class="text-center">{{ $t("experiences.new") }}</h1>
      <form @submit.prevent="onCreate" class="text-left">
          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="title">{{ $t("experiences.name") }}</label>
            <input class="form-input rounded-lg" v-model="newExperience.name" id="title" type="text" required />
          </div>

          <fieldset class="flex flex-row justify-around border rounded mb-2">
            <legend class="p-0.5 ml-2">{{ $t("experiences.type.title") }}</legend>
              <div class="mb-2">
                <input type="radio" class="rounded text-violet" value="education" v-model="selectedType"/>
                <label class="ml-1"> {{ $t("experiences.type.educational") }}</label>
              </div>
              <div class="mb-3 ml-2">
                <input type="radio" class="rounded text-violet" value="professional" v-model="selectedType"/>
                <label class="ml-1"> {{ $t("experiences.type.professional") }}</label>
              </div>
          </fieldset>

          <div v-if="selectedType === 'education'" class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="degree">{{ $t("experiences.degree") }}</label>
            <input class="form-input rounded-lg" v-model="newExperience.degree" id="degree"/>
          </div>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="startDate">{{ $t("experiences.startDate") }}</label>
            <input class="form-input rounded-lg" v-model="newExperience.startDate" id="startDate"/>
          </div>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="endDate">{{ $t("experiences.endDate") }}</label>
            <input class="form-input rounded-lg" v-model="newExperience.endDate" id="endDate" />
          </div>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="position">{{ $t("experiences.position") }} {{ $t("experiences.optional") }}</label>
            <input class="form-input rounded-lg" v-model="newExperience.position" id="position" type="text" />
          </div>

          <fieldset class="flex flex-row justify-around border rounded mb-2">
            <legend class="p-0.5 ml-2">{{ $t("experiences.company.info")}}</legend>
            <div class="flex flex-col mb-2">
              <label class="text-white text-opacity-50 text-sm mb-1" for="companyLogo">{{ $t("experiences.company.logo")}}</label>
              <input class="form-input rounded-lg" v-model="newExperience.companyLogo" id="companyLogo" type="text" />
            </div>

            <div class="flex flex-col mb-2">
              <label class="text-white text-opacity-50 text-sm mb-1" for="companyName">{{ $t("experiences.company.name")}}</label>
              <input class="form-input rounded-lg" v-model="newExperience.companyName" id="companyName" type="text" />
            </div>
          </fieldset>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="status">{{ $t("experiences.status") }} {{ $t("experiences.optional")}}</label>
            <input class="form-input rounded-lg" v-model="newExperience.status" id="status" type="text" />
          </div>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="missionDetails">{{ $t("experiences.missionDetails") }} {{ $t("experiences.optional")}}</label>
            <textarea class="form-input rounded-lg" v-model="newExperience.missionDetails" id="missionDetails" type="text" />
          </div>

          <div class="flex flex-col mb-2">
            <label class="text-white text-opacity-50 text-sm mb-1" for="misc">{{ $t("experiences.misc") }} {{ $t("experiences.optional")}}</label>
            <textarea class="form-input rounded-lg" v-model="newExperience.misc" id="misc" type="text" />
          </div>

          <fieldset class="flex flex-row justify-around border rounded mb-2">
            <legend class="p-0.5 ml-2">{{ $t("skills.title") }}</legend>
            <div class="grid grid-cols-2 gap-4 mb-2 ">
              <div v-for="skill in skills" :key="skill.id" class="flex flex-row items-center">
                <input type="checkbox" class="rounded text-indigo" :value="skill.id" v-model="selectedSkillIDs" />
                <p class="ml-1">{{ skill.name }}</p>
              </div>
            </div>
          </fieldset>

          <fieldset class="flex flex-row justify-around border rounded mb-2">
            <legend class="p-0.5 ml-2">{{ $t("projects.title") }}</legend>
            <div class="grid grid-cols-2 gap-4 mb-2 ">
              <div v-for="project in projects" :key="project.id" class="flex flex-row items-center">
                <input type="checkbox" class="rounded text-indigo" :value="project.id" v-model="selectedProjectIDs" />
                <p class="ml-1">{{ project.name }}</p>
              </div>
            </div>
          </fieldset>

          <div class="text-center">
            <BaseButton class="bg-indigo hover:bg-indigo-dark" type="submit"> {{ $t("utils.create") }} </BaseButton>
            <CancelButton/>
          </div>
        </form>
    </div>
  </div>
</template>

<style scoped>

</style>