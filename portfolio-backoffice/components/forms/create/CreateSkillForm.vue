<script setup lang="ts">
import BaseButton from "~/components/buttons/BaseButton.vue";
import useProjects from "~/composables/useProjects";
import useSkills from "~/composables/useSkills";
import {ref} from "vue";
import type {Project} from "~/types/project";
import CancelButton from "~/components/buttons/CancelButton.vue";
import type {Experience} from "~/types/experience";
import useExperiences from "~/composables/useExperiences";

const { getProjects } = useProjects();
const { getExperiences } = useExperiences();
const { createSkill, newSkill } = useSkills();
const projects = ref<Project[]>([]);
const experiences = ref<Experience[]>([]);
const selectedProjectIDs = ref([]);
const selectedExperienceIDs = ref([]);

onMounted(async () => {
  await onInit();
});

async function onInit() {
  try {
    projects.value = await getProjects();
    experiences.value = await getExperiences();
  } catch (error) {
    console.error(error);
  }
}

async function onSubmit() {
  try {
    newSkill.value.tags = newSkill.value.tags.split(',').map(tag => tag.trim());
    newSkill.value.projects = selectedProjectIDs.value;
    newSkill.value.experiences = selectedExperienceIDs.value;
    await createSkill(newSkill.value);
    await navigateTo("/skills");
  } catch (error) {
    console.error("Error creating skill:", error);
  }
}
</script>

<template>
  <div class="flex flex-col">
    <div class="card-container items-center">
      <h1 class="text-center">{{ $t("skills.new") }}</h1>
      <form @submit.prevent="onSubmit" class="text-align-left">
        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="name">Name</label>
          <input class="form-input rounded-lg" v-model="newSkill.name" id="name" type="text" required />
        </div>

        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="tags">{{ $t("skills.tags") }}</label>
          <input class="form-input rounded-lg" v-model="newSkill.tags" id="tags" type="text" placeholder="e.g. JavaScript, Web Development" required />
        </div>

        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="context">{{ $t("skills.context") }}</label>
          <textarea class="form-input rounded-lg" v-model="newSkill.context" id="context" required></textarea>
        </div>

        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="proofs">{{ $t("skills.proofs") }}</label>
          <textarea class="form-input rounded-lg" v-model="newSkill.proofs" id="proofs" required></textarea>
        </div>

        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="retrospective">{{ $t("skills.retrospective") }}</label>
          <textarea class="form-input rounded-lg" v-model="newSkill.retrospective" id="retrospective" required></textarea>
        </div>

        <div class="flex flex-col mb-2">
          <label class="text-white text-opacity-50 text-sm mb-1" for="progress">{{ $t("skills.progress") }}</label>
          <textarea class="form-input rounded-lg" v-model="newSkill.progress" id="progress" type="text" required />
        </div>

        <fieldset v-if="projects.length > 0" class="flex flex-row justify-around border rounded mb-2">
          <legend class="p-0.5 ml-2">{{ $t("projects.title") }}</legend>
          <div class="grid grid-cols-2 gap-4 mb-2 ">
            <div v-for="project in projects" :key="project.id" class="flex flex-row items-center">
              <input type="checkbox" class="rounded text-pink" :value="project.id" v-model="selectedProjectIDs" />
              <p class="ml-1">{{ project.name }}</p>
            </div>
          </div>
        </fieldset>

        <fieldset v-if="experiences.length > 0" class="flex flex-row justify-around border rounded mb-2">
          <legend class="p-0.5 ml-2">{{ $t("projects.title") }}</legend>
          <div class="grid grid-cols-2 gap-4 mb-2 ">
            <div v-for="exp in experiences" :key="exp.id" class="flex flex-row items-center">
              <input type="checkbox" class="rounded text-pink" :value="exp.id" v-model="selectedExperienceIDs" />
              <p class="ml-1">{{ exp.name }}</p>
            </div>
          </div>
        </fieldset>

        <div class="text-center">
          <BaseButton class="bg-pink hover:bg-pink-dark" type="submit"> {{ $t("utils.create") }} </BaseButton>
          <CancelButton/>
        </div>

      </form>
    </div>
  </div>
</template>

<style scoped>

</style>