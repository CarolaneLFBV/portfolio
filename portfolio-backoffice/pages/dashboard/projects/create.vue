<script lang="ts" setup>
import {navigateTo} from "#app";
import {definePageMeta, useI18n} from "#imports";
import useProject from "~/composables/useProject";
import TypeSelector from "~/components/inputs/TypeSelector.vue";
import LogoInput from "~/components/inputs/LogoInput.vue";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth', 'role']
});

const {t} = useI18n();
const {createProject, newProject} = useProject();
let selectedLogo: File | null;

const onSubmit = async () => {
  const formData = new FormData();
  formData.append('name', newProject.value.name);
  formData.append('type', newProject.value.type);
  formData.append('link', newProject.value.link);
  formData.append('presentation', newProject.value.presentation);

  if (selectedLogo != null) {
    formData.append('logo', selectedLogo);
  }
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
          <Label for="link">{{ t("app.link") }}</Label>
          <Input id="link" v-model="newProject.link" required/>
        </div>

        <div class="mb-2">
          <Label for="presentation">{{ t("projects.presentation") }}</Label>
          <Textarea id="presentation" v-model="newProject.presentation" required/>
        </div>

        <LogoInput v-model:logo="selectedLogo"/>

        <div class="flex flex-row gap-2">
          <Button variant="secondary" @click="$router.back()">{{ t("utils.cancel") }}</Button>
          <Button type="submit">{{ t("utils.create") }}</Button>
        </div>
      </form>
    </div>
  </div>
</template>


