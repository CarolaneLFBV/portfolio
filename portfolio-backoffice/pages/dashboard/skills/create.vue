<script lang="ts" setup>
import useSkills from "~/composables/useSkill";
import {navigateTo} from "#app";
import {definePageMeta, useI18n} from "#imports";
import ArrayInput from "~/components/inputs/ArrayInput.vue";
import LogoInput from "~/components/inputs/LogoInput.vue";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth', 'role']
});

const {t} = useI18n();
const {createSkill, newSkill} = useSkills();
let selectedLogo: File | null;

const onSubmit = async () => {
  const formData = new FormData();
  formData.append('name', newSkill.value.name);
  newSkill.value.tags.forEach(tag => formData.append('tags[]', tag));

  if (selectedLogo != null) {
    formData.append('image', selectedLogo);
  }

  await createSkill(formData);
  await navigateTo({path: `/dashboard/skills`});
};

</script>

<template>
  <div class="flex items-center justify-center min-h-screen overflow-auto py-10">
    <div class="max-w-4xl w-full mx-auto p-6">
      <h2 class="text-3xl font-bold tracking-tight my-4 text-center">
        {{ t("skills.new") }}
      </h2>
      <form @submit.prevent="onSubmit">
        <div class="mb-2">
          <Label for="name">{{ t("skills.name") }}</Label>
          <Input id="name" v-model="newSkill.name" required/>
        </div>

        <div class="mb-2">
          <Label for="tags">{{ t("skills.tags") }}</Label>
          <ArrayInput v-model:tags="newSkill.tags"/>
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


