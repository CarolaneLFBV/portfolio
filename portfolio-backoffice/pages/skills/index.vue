<script setup lang="ts">
import {definePageMeta} from "#imports";
import {ref} from "vue";
import {useRouter} from "#vue-router";
import type {Skill} from "~/types/skill";
import useSkills from "~/composables/useSkills";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

const { getSkills } = useSkills()
const router = useRouter();
const skills = ref<Skill[]>([]);

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

function editSkill(id: string) {
  router.push(`/skills/${id}`);
}
</script>

<template>
  <h2>{{ $t("skills.title") }}</h2>
  <div v-if="skills" class="flex-row flex-wrap">
    <div v-for="skill in skills" :key="skill.id" class="card-container margin text-align-left">
      <p><strong>{{ $t("skills.unique") }}:</strong> {{ skill.name }} </p>
      <div class="flex-row flex-wrap">
        <strong>{{ $t("skills.tags") }}:</strong>
        <p v-for="tag in skill.tags"> {{ tag }} </p>
      </div>

      <div class="text-align-right"><button @click="editSkill(skill.id)">Edit</button></div>
    </div>
  </div>
  <div v-else>
    <p>Chargement de la liste des compétences...</p>
  </div>

  <div class="margin">
    <NuxtLink class="link-btn" to="/skills/create">Create Skill</NuxtLink>
  </div>
</template>

<style scoped>

</style>