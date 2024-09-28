<script setup lang="ts">
import { ref } from 'vue';
import type { SkillCreation } from '~/types/skill'; // Import your SkillCreation type
import useSkills from "~/composables/useSkills";
import {definePageMeta} from "#imports"; // Assuming you have a composable to handle API interactions

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

// Initialize the form data
const newSkill = ref<SkillCreation>({
  name: '',
  tags: [],
  context: '',
  proofs: '',
  retrospective: '',
  progress: ''
});

const { createSkill } = useSkills();

async function onSubmit() {
  try {
    await createSkill(newSkill.value);
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
            <!-- Name input -->
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

            <!-- Retrospective input -->
            <div>
              <label for="retrospective">Retrospective</label>
              <textarea v-model="newSkill.retrospective" id="retrospective" required></textarea>
            </div>

            <!-- Progress input -->
            <div>
              <label for="progress">Progress</label>
              <textarea v-model="newSkill.progress" id="progress" type="text" required />
            </div>

            <button type="submit">Create Skill</button>
          </form>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
