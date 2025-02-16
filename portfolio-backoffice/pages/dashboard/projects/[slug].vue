<script lang="ts" setup>
import {onMounted, ref} from "vue";
import {useRoute} from "#vue-router";
import {useI18n} from "#imports";
import useProject from "~/composables/useProject";
import useSkill from "~/composables/useSkill";
import useExperience from "~/composables/useExperience";
import type {Skill} from "~/types/skill";
import {Textarea} from "~/components/ui/textarea";
import type {ProjectInput} from "~/types/project";
import type {Experience} from "~/types/experience";
import {navigateTo} from "#app";
import LogoInput from "~/components/inputs/LogoInput.vue";
import SelectableList from "~/components/list/SelectableList.vue";
import TypeSelector from "~/components/inputs/TypeSelector.vue";
import ImagesInput from "~/components/inputs/ImagesInput.vue";

const route = useRoute();
const slug = route.params.slug as string;
const {t} = useI18n();

const {getProjectBySlug, updateProject} = useProject();
const {getExperiences} = useExperience();
const {getSkills} = useSkill();

const project = ref<ProjectInput>();
const experiences = ref<Experience[]>([]);
const skills = ref<Skill[]>([]);
const selectedExperienceIDs = ref<string[]>([]);
const selectedSkillIDs = ref<string[]>([]);

let selectedLogo: File | null;
const selectedImages = ref<File[]>([]);

const onInit = async () => {
  if (slug) {
    try {
      project.value = await getProjectBySlug(slug);
      skills.value = await getSkills();
      experiences.value = await getExperiences();
      selectedExperienceIDs.value = project.value.experiences || [];
      selectedSkillIDs.value = project.value.skills || [];
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
  project.value.projects = selectedExperienceIDs.value;
  project.value.skills = selectedSkillIDs.value;

  formData.append('name', project.value.name);
  formData.append('type', project.value.type);
  formData.append('presentation', project.value.presentation);

  project.value.experiences.forEach(experienceId => {
    formData.append('experiences[]', experienceId);
  });
  project.value.skills.forEach(skillId => {
    formData.append('skills[]', skillId);
  });

  if (selectedLogo != null) {
    formData.append('logo', selectedLogo);
  }

  selectedImages.value.forEach(image => {
    formData.append("images[]", image);
  });

  await updateProject(slug, formData);
  await navigateTo({path: `/dashboard/projects/`});
};
</script>

<template>
  <div v-if="project" class="flex items-center justify-center min-h-screen overflow-auto py-10">
    <div class="max-w-4xl w-full mx-auto p-6">
      <h2 class="text-3xl font-bold tracking-tight my-4 text-center">
        {{ t("utils.edit") }} {{ project.name }}
      </h2>
      <form class="space-y-4" @submit.prevent="onSubmit">
        <div class="mb-2">
          <Label for="name">{{ t("projects.name") }}</Label>
          <Input id="name" v-model="project.name" required/>
        </div>

        <div class="mb-2">
          <Label for="type">{{ t("projects.type") }}</Label>
          <TypeSelector v-model:type="project.type" :placeholder="project.type"/>
        </div>

        <div class="mb-2">
          <Label for="presentation">{{ t("projects.presentation") }}</Label>
          <Textarea id="presentation" v-model="project.presentation" required/>
        </div>

        <SelectableList v-model:selectedItems="selectedExperienceIDs" :items="experiences"
                        :title="t('projects.title')"/>
        <SelectableList v-model:selectedItems="selectedSkillIDs" :items="skills" :title="t('skills.title')"/>

        <LogoInput v-model:logo="selectedLogo"/>
        <ImagesInput v-model:images="selectedImages"/>

        <div class="flex flex-row gap-2">
          <Button variant="secondary" @click="$router.back()">{{ t("utils.cancel") }}</Button>
          <Button type="submit">{{ t("utils.update") }}</Button>
        </div>
      </form>
    </div>
  </div>
</template>