<script setup lang="ts">
import {useRoute} from "#vue-router";
import {ref} from "vue";
import type {Skill} from "~/types/skill";
import type {Project} from "~/types/project";
import useProjects from "~/composables/useProjects";
import useSkills from "~/composables/useSkills";

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
    <div class="full-height flex-column text-align-center">
      <div class="card-container text-align-center">

        <h1>Modifier Projet: {{ project.title }}</h1>
        <form @submit.prevent="onUpdate">
          <div>
            <label for="title">Titre</label>
            <input v-model="project.title" id="title" type="text" required />
          </div>

          <div>
            <label for="presentation">Présentation</label>
            <textarea v-model="project.presentation" id="presentation"></textarea>
          </div>

          <div>
            <label for="purpose">Objectif</label>
            <textarea v-model="project.purpose" id="purpose"></textarea>
          </div>

          <div>
            <label for="milestone">Jalon</label>
            <textarea v-model="project.milestone" id="milestone"></textarea>
          </div>

          <div>
            <label for="actor">Acteur</label>
            <input v-model="project.actor" id="actor" type="text" />
          </div>

          <div>
            <label for="progress">Progression</label>
            <input v-model="project.progress" id="progress" type="text" />
          </div>

          <!-- Skills Selection -->
          <fieldset>
            <legend>Compétences :</legend>
            <div class="checkboxes flex-row flex-wrap">
              <div v-for="skill in skills" :key="skill.id">
                <input type="checkbox" :value="skill.id" v-model="selectedSkillIDs" />
                <p>{{ skill.name }}</p>
              </div>
            </div>
          </fieldset>

          <button type="submit">Mettre à jour</button>
        </form>
      </div>
    </div>
  </div>
</template>

<style scoped>
.checkboxes {

}
</style>