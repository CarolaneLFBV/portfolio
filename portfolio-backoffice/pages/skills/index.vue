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
</script>

<template>
  <h1>{{ $t("dashboard.title") }}</h1>
  <h2>PROJECTS</h2>
  <div v-for="skill in skills" :key="skill.id" class="card-container margin text-align-left">
    <p><strong>{{ $t("project.title") }}:</strong> {{ skill.name }} </p>
  </div>
  <button>Add Skill</button>
</template>

<style scoped>

</style>