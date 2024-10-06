<script setup lang="ts">
import useSkills from "~/composables/useSkills";
import {definePageMeta} from "#imports";
import {ref} from "vue";
import type {Project} from "~/types/project";
import useProjects from "~/composables/useProjects";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

const { getProjects } = useProjects()
const { createSkill, newSkill } = useSkills();
const projects = ref<Project[]>([]);
const selectedProjectIDs = ref([]);

onMounted(async () => {
  await onInit();
});

async function onInit() {
  try {
    projects.value = await getProjects();
  } catch (error) {
    console.error(error);
  }
}

async function onSubmit() {
  try {
    newSkill.value.tags = newSkill.value.tags.split(',').map(tag => tag.trim());
    newSkill.value.projects = selectedProjectIDs.value;
    await createSkill(newSkill.value);
    await navigateTo("/skills");
  } catch (error) {
    console.error("Error creating skill:", error);
  }
}
</script>

<template>
  <div class="full-height flex-column text-align-center">
    <div class="card-container">
      <div class="text-align-center">
          <h1>Create New Skill</h1>
          <form @submit.prevent="onSubmit" class="text-align-left">
            <div class="padding-bottom">
              <label for="name">Name</label>
              <input v-model="newSkill.name" id="name" type="text" required />
            </div>

            <div>
              <label for="tags">Tags (comma-separated)</label>
              <input v-model="newSkill.tags" id="tags" type="text" placeholder="e.g. JavaScript, Web Development" required />
            </div>

            <div>
              <label for="context">Context</label>
              <textarea v-model="newSkill.context" id="context" required></textarea>
            </div>

            <div>
              <label for="proofs">Proofs</label>
              <textarea v-model="newSkill.proofs" id="proofs" required></textarea>
            </div>

            <div>
              <label for="retrospective">Retrospective</label>
              <textarea v-model="newSkill.retrospective" id="retrospective" required></textarea>
            </div>

            <div>
              <label for="progress">Progress</label>
              <textarea v-model="newSkill.progress" id="progress" type="text" required />
            </div>

            <div>
              <label>Skills:</label>
              <div v-for="project in projects" :key="project.id">
                <input type="checkbox" :value="project.id" v-model="selectedProjectIDs" />
                {{ project.name }}
              </div>
            </div>


            <button type="submit">Create Skill</button>
          </form>
      </div>
    </div>
  </div>
</template>

<style scoped>
</style>
