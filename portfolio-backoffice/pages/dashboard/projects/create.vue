<script lang="ts" setup>
import {navigateTo} from "#app";
import {useI18n} from "#imports";
import useProject from "~/composables/useProject";
import TypeSelector from "~/components/inputs/TypeSelector.vue";

const {t} = useI18n();
const {createProject, newProject} = useProject();

const onSubmit = async () => {
  const formData = new FormData();
  formData.append('name', newProject.value.name);
  formData.append('type', newProject.value.type);
  formData.append('introduction', newProject.value.introduction);
  formData.append('presentation', newProject.value.presentation);

  formData.append('background[problemStatement]', newProject.value.background.problemStatement);
  formData.append('background[projectRole]', newProject.value.background.projectRole);
  formData.append('background[achievedGoals]', newProject.value.background.achievedGoals);

  formData.append('technicalDetails[technicalChoices]', newProject.value.technicalDetails.technicalChoices);
  formData.append('technicalDetails[challenges]', newProject.value.technicalDetails.challenges);
  formData.append('technicalDetails[solutions]', newProject.value.technicalDetails.solutions);

  await createProject(formData);
  await navigateTo({path: `/dashboard/projects`});
};
</script>

<template>
  <div class="flex items-center justify-center min-h-screen overflow-auto py-10">
    <div class="max-w-4xl w-full mx-auto p-6">
      <h2 class="text-3xl font-bold tracking-tight my-4 text-center">
        {{ t("projects.new") }}
      </h2>
      <form @submit.prevent="onSubmit">
        <div class="mb-2">
          <Label for="name">{{ t("projects.name") }}</Label>
          <Input id="name" v-model="newProject.name" required/>
        </div>

        <div class="mb-2">
          <Label for="type">{{ t("projects.type") }}</Label>
          <TypeSelector v-model:type="newProject.type"/>
        </div>

        <div class="mb-2">
          <Label for="introduction">{{ t("projects.introduction") }}</Label>
          <Textarea id="introduction" v-model="newProject.introduction" required/>
        </div>

        <div class="mb-2">
          <Label for="presentation">{{ t("projects.presentation") }}</Label>
          <Textarea id="presentation" v-model="newProject.presentation" required/>
        </div>

        <div class="mb-2">
          <Label for="problemStatement">{{ t("projects.background.problem-statement") }}</Label>
          <Textarea id="problemStatement" v-model="newProject.background.problemStatement" required/>
        </div>

        <div class="mb-2">
          <Label for="projectRole">{{ t("projects.background.project-role") }}</Label>
          <Textarea id="projectRole" v-model="newProject.background.projectRole" required/>
        </div>

        <div class="mb-2">
          <Label for="achievedGoals">{{ t("projects.background.achieved-goals") }}</Label>
          <Textarea id="achievedGoals" v-model="newProject.background.achievedGoals" required/>
        </div>

        <div class="mb-2">
          <Label for="technicalChoices">{{ t("projects.technical-details.technical-choices") }}</Label>
          <Textarea id="technicalChoices" v-model="newProject.technicalDetails.technicalChoices" required/>
        </div>

        <div class="mb-2">
          <Label for="challenges">{{ t("projects.technical-details.challenges") }}</Label>
          <Textarea id="challenges" v-model="newProject.technicalDetails.challenges" required/>
        </div>

        <div class="mb-2">
          <Label for="solutions">{{ t("projects.technical-details.solutions") }}</Label>
          <Textarea id="solutions" v-model="newProject.technicalDetails.solutions" required/>
        </div>

        <div class="flex flex-row gap-2">
          <Button variant="secondary" @click="$router.back()">{{ t("utils.cancel") }}</Button>
          <Button type="submit">{{ t("utils.create") }}</Button>
        </div>
      </form>
    </div>
  </div>
</template>


