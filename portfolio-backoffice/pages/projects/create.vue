<script setup lang="ts">
import {definePageMeta} from "#imports";
import useProjects from "~/composables/useProjects";
import useSkills from "~/composables/useSkills";
import {ref} from "vue";
import type {Skill} from "~/types/skill";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

const { createProject, newProject } = useProjects();
const { getSkills } = useSkills();
const skills = ref<Skill[]>([]);
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

async function onSubmit() {
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
  <div class="full-height flex-column text-align-center">
    <div class="card-container">
      <div class="text-align-center">
        <h1>Create New Project</h1>
        <form @submit.prevent="onSubmit" class="text-align-left">
          <div class="padding-bottom">
            <label for="name">Name</label>
            <input v-model="newProject.title" id="name" type="text" required />
          </div>

          <div>
            <label for="tags">Tags (comma-separated)</label>
            <input v-model="newProject.presentation" id="tags" type="text" placeholder="e.g. JavaScript, Web Development" required />
          </div>

          <div>
            <label for="context">Context</label>
            <textarea v-model="newProject.purpose" id="context" required></textarea>
          </div>

          <div>
            <label for="proofs">Proofs</label>
            <textarea v-model="newProject.milestone" id="proofs" required></textarea>
          </div>

          <div>
            <label for="retrospective">Retrospective</label>
            <textarea v-model="newProject.actor" id="retrospective" required></textarea>
          </div>

          <div>
            <label for="progress">Progress</label>
            <textarea v-model="newProject.progress" id="progress" type="text" required />
          </div>

          <fieldset>
            <legend>{{ $t("skills.title") }}</legend>
            <div v-for="skill in skills" :key="skill.id" class="flex-row">
              <input type="checkbox" :value="skill.id" v-model="selectedSkillIDs" />
              <p>{{ skill.name }}</p>
            </div>
          </fieldset>

          <button type="submit">Create Skill</button>
        </form>
      </div>
    </div>
  </div>
</template>

<style scoped>
input {
  width: auto;
}
</style>
