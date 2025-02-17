<script lang="ts" setup>
import {onMounted, ref} from "vue";
import {useRoute} from "#vue-router";
import {definePageMeta, useI18n} from "#imports";
import useSkills from "~/composables/useSkill";
import useProjects from "~/composables/useProject";
import useExperiences from "~/composables/useExperience";
import type {SkillInput} from "~/types/skill";
import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";
import SelectableList from "~/components/list/SelectableList.vue";
import ArrayInput from "~/components/inputs/ArrayInput.vue";
import LogoInput from "~/components/inputs/LogoInput.vue";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth', 'role']
});

const route = useRoute();
const slug = route.params.slug as string;
const {t} = useI18n();

const {getSkillBySlug, updateSkill} = useSkills();
const {getProjects} = useProjects();
const {getExperiences} = useExperiences();

const skill = ref<SkillInput>();
const projects = ref<Project[]>([]);
const experiences = ref<Experience[]>([]);
const selectedProjectIDs = ref<string[]>([]);
const selectedExperienceIDs = ref<string[]>([]);
let selectedLogo: File | null;

const onInit = async () => {
  if (slug) {
    try {
      skill.value = await getSkillBySlug(slug);
      skill.value.tags = skill.value.tags || [];
      projects.value = await getProjects();
      experiences.value = await getExperiences();
      selectedProjectIDs.value = skill.value.projects || [];
      selectedExperienceIDs.value = skill.value.experiences || [];
    } catch (error) {
      console.error("Erreur lors de la récupération du skill :", error);
    }
  }
};

onMounted(async () => {
  await onInit();
});

const onSubmit = async () => {
  const formData = new FormData();
  skill.value.projects = selectedProjectIDs.value;
  skill.value.experiences = selectedExperienceIDs.value;

  formData.append('name', skill.value.name);
  skill.value.tags.forEach(tag => formData.append('tags[]', tag));

  skill.value.projects.forEach(projectId => {
    formData.append('projects[]', projectId);
  });
  skill.value.experiences.forEach(experienceId => {
    formData.append('experiences[]', experienceId);
  });

  if (selectedLogo != null) {
    formData.append('image', selectedLogo);
  }
  await updateSkill(slug, formData);
  await navigateTo({path: `/dashboard/skills/`});
};
</script>

<template>
  <div v-if="skill" class="flex items-center justify-center min-h-screen overflow-auto py-10">
    <div class="max-w-4xl w-full mx-auto p-6">
      <h2 class="text-3xl font-bold tracking-tight my-4 text-center">
        {{ t("utils.edit") }} {{ skill.name }}
      </h2>
      <form @submit.prevent="onSubmit">
        <div class="mb-2">
          <Label for="name">{{ t("skills.name") }}</Label>
          <Input id="name" v-model="skill.name"/>
        </div>

        <div class="mb-2">
          <Label for="tags">{{ t("skills.tags") }}</Label>
          <ArrayInput v-model:tags="skill.tags"/>
        </div>

        <SelectableList
            v-model:selectedItems="selectedProjectIDs"
            :items="projects"
            :title="t('projects.title')"
        />

        <SelectableList
            v-model:selectedItems="selectedExperienceIDs"
            :items="experiences"
            :title="t('experiences.title')"
        />

        <LogoInput v-model:logo="selectedLogo"/>

        <div class="flex flex-row gap-2">
          <Button variant="secondary" @click="$router.back()">{{ t("utils.cancel") }}</Button>
          <Button type="submit">{{ t("utils.update") }}</Button>
        </div>
      </form>
    </div>
  </div>
</template>
