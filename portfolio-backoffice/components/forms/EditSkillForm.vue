<script setup lang="ts">
import {ref} from "vue";
import {useRoute} from "#vue-router";
import {definePageMeta} from "#imports";
import type {Skill} from "~/types/skill";
import useSkills from "~/composables/useSkills";

definePageMeta({
  layout: 'layout-dashboard',
})


const { getSkillByID, updateSkill, splitTags } = useSkills();
const skill = ref<Skill | null>(null);
const route = useRoute();

onMounted(async () => {
  await onInit();
});

async function onInit() {
  try {
    const skillId = route.params.id;
    if (skillId) {
      const skillData = await getSkillByID(skillId);
      skill.value = skillData;
    }
  } catch (error) {
    console.error("Erreur lors de la récupération de l'utilisateur :", error);
  }
}

async function update() {
  try {
    skill.value.tags = skill.value.tags.split(',').map(tag => tag.trim());
    await updateSkill(skill.value);
  } catch (error) {
    console.error(error);
  }
}
</script>

<template>
  <div v-if="skill">
    <div class="full-height flex-column text-align-center">
      <div class="card-container text-align-center">
          <h1>{{ $t("utils.edit") }} {{ skill.name }}</h1>
          <form @submit.prevent="update" class="skill-form">
            <!-- Name -->
            <div class="padding-bottom text-align-left">
              <label for="name">Name</label>
              <input v-model="skill.name" id="name" type="text" required />
            </div>

            <!-- Tags -->
            <div class="padding-bottom text-align-left full-width">
              <label for="tags">Tags (comma-separated)</label>
              <input
                  v-model="skill.tags"
                  id="tags"
                  type="text"
                  placeholder="e.g. JavaScript, Web Development"
                  required
              />
            </div>

            <!-- Context -->
            <div class="padding-bottom text-align-left">
              <label for="context">Context</label>
              <textarea v-model="skill.context" id="context" required></textarea>
            </div>

            <!-- Proofs -->
            <div class="padding-bottom text-align-left">
              <label for="proofs">Proofs</label>
              <textarea v-model="skill.proofs" id="proofs" required></textarea>
            </div>

            <!-- Retrospective -->
            <div class="padding-bottom text-align-left">
              <label for="retrospective">Retrospective</label>
              <textarea v-model="skill.retrospective" id="retrospective" required></textarea>
            </div>

            <!-- Progress -->
            <div class="padding-bottom text-align-left">
              <label for="progress">Progress</label>
              <textarea v-model="skill.progress" id="progress" required></textarea>
            </div>

            <!-- Submit button -->
            <button type="submit">Update Skill</button>
          </form>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>