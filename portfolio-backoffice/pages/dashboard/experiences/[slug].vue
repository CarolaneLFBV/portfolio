<script lang="ts" setup>
import {definePageMeta, useI18n} from "#imports";
import {useRoute} from "#vue-router";
import useExperience from "~/composables/useExperience";
import useSkill from "~/composables/useSkill";
import useProjects from "~/composables/useProject";
import type {Skill} from "~/types/skill";
import type {Project} from "~/types/project";
import type {ExperienceInput} from "~/types/experience";
import {navigateTo} from "#app";
import LogoInput from "~/components/inputs/LogoInput.vue";
import SelectableList from "~/components/list/SelectableList.vue";
import TypeSelector from "~/components/inputs/TypeSelector.vue";
import ArrayInput from "~/components/inputs/ArrayInput.vue";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth', 'role']
});

const route = useRoute();
const slug = route.params.slug as string;
const {t} = useI18n();

const {getExperienceBySlug, updateExperience} = useExperience();
const {getProjects} = useProjects();
const {getSkills} = useSkill();

const experience = ref<ExperienceInput>();
const projects = ref<Project[]>([]);
const skills = ref<Skill[]>([]);
const selectedProjectIDs = ref<string[]>([]);
const selectedSkillIDs = ref<string[]>([]);

let selectedLogo: File | null;

const onInit = async () => {
  if (slug) {
    try {
      experience.value = await getExperienceBySlug(slug);
      projects.value = await getProjects();
      skills.value = await getSkills();
      selectedProjectIDs.value = experience.value.projects || [];
      selectedSkillIDs.value = experience.value.skills || [];
    } catch (error) {
      console.error("Erreur lors de la récupération du skill :", error);
    }
  }
}

onMounted(async () => {
  await onInit();
});

const onSubmit = async () => {
  const formData = new FormData();
  experience.value.projects = selectedProjectIDs.value;
  experience.value.skills = selectedSkillIDs.value;

  formData.append('name', experience.value.name);
  formData.append('type', experience.value.type);
  formData.append('link', experience.value.link);
  formData.append('period[startDate]', experience.value.period.startDate);
  formData.append('period[endDate]', experience.value.period.endDate);
  formData.append('companyName', experience.value.companyName);
  experience.value.missionDetails.forEach(md => formData.append('missionDetails[]', md));

  experience.value.projects.forEach(projectId => {
    formData.append('projects[]', projectId);
  });
  experience.value.skills.forEach(skillId => {
    formData.append('skills[]', skillId);
  });

  if (selectedLogo != null) {
    formData.append('logo', selectedLogo);
  }
  await updateExperience(slug, formData);
  await navigateTo({path: `/dashboard/experiences/`});
};
</script>

<template>
  <div v-if="experience" class="flex items-center justify-center min-h-screen overflow-auto py-10">
    <div class="max-w-4xl w-full mx-auto p-6">
      <h2 class="text-3xl font-bold tracking-tight my-4 text-center">
        {{ t("utils.edit") }} {{ experience.name }}
      </h2>
      <form @submit.prevent="onSubmit">
        <div class="mb-2">
          <Label for="name">{{ t("experiences.name") }}</Label>
          <Input id="name" v-model="experience.name" required/>
        </div>

        <div class="mb-2">
          <Label for="type">{{ t("experiences.type") }}</Label>
          <TypeSelector
              v-model:type="experience.type"
              :placeholder="experience.type"
              option-one="professional"
              option-two="educational"
          />
        </div>

        <div class="mb-2">
          <Label for="type">{{ t("app.link") }}</Label>
          <Input id="name" v-model="experience.link" required/>
        </div>

        <div class="mb-2">
          <Label for="startDate">{{ t("experiences.period.start-date") }}</Label>
          <Input id="startDate" v-model="experience.period.startDate" required/>
        </div>

        <div class="mb-2">
          <Label for="endDate">{{ t("experiences.period.end-date") }}</Label>
          <Input id="endDate" v-model="experience.period.endDate" required/>
        </div>

        <div class="mb-2">
          <Label for="companyName">{{ t("experiences.company-name") }}</Label>
          <Input id="companyName" v-model="experience.companyName" required/>
        </div>

        <div class="mb-2">
          <Label for="missionDetails">{{ t("experiences.mission-details") }}</Label>
          <ArrayInput v-model:tags="experience.missionDetails"/>
        </div>

        <div class="mb-2">
          <Label for="tags">{{ t("skills.tags") }}</Label>
        </div>
        <SelectableList
            v-model:selectedItems="selectedProjectIDs"
            :items="projects"
            :title="t('projects.title')"
        />

        <SelectableList
            v-model:selectedItems="selectedSkillIDs"
            :items="skills"
            :title="t('skills.title')"
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