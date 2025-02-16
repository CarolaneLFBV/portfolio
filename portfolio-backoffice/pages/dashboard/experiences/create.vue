<script lang="ts" setup>
import {Textarea} from "~/components/ui/textarea";
import {navigateTo} from "#app";
import {useI18n} from "#imports";
import useExperience from "~/composables/useExperience";
import TypeSelector from "~/components/inputs/TypeSelector.vue";

const {t} = useI18n();
const {createExperience, newExperience} = useExperience();

const onSubmit = async () => {
  const formData = new FormData();
  formData.append('name', newExperience.value.name);
  formData.append('type', newExperience.value.type);
  formData.append('period[startDate]', newExperience.value.period.startDate);
  formData.append('period[endDate]', newExperience.value.period.endDate);
  formData.append('companyName', newExperience.value.companyName);
  formData.append('missionDetails', newExperience.value.missionDetails);
  await createExperience(formData);
  await navigateTo({path: `/dashboard/experiences`});
};
</script>

<template>
  <div class="flex items-center justify-center min-h-screen overflow-auto py-10">
    <div class="max-w-4xl w-full mx-auto p-6">
      <h2 class="text-3xl font-bold tracking-tight my-4 text-center">
        {{ t("experiences.new") }}
      </h2>
      <form @submit.prevent="onSubmit">
        <div class="mb-2">
          <Label for="type">{{ t("experiences.name") }}</Label>
          <Input id="name" v-model="newExperience.name" required/>
        </div>

        <div class="mb-2">
          <Label for="type">{{ t("experiences.type") }}</Label>
          <TypeSelector v-model:type="newExperience.type"/>
        </div>

        <div class="mb-2">
          <Label for="startDate">{{ t("experiences.period.start-date") }}</Label>
          <Input id="startDate" v-model="newExperience.period.startDate" required/>
        </div>

        <div class="mb-2">
          <Label for="endDate">{{ t("experiences.period.end-date") }}</Label>
          <Input id="endDate" v-model="newExperience.period.endDate" required/>
        </div>

        <div class="mb-4">
          <Label for="companyName">{{ t("experiences.company-name") }}</Label>
          <Input id="companyName" v-model="newExperience.companyName" required/>
        </div>

        <div class="mb-4">
          <Label for="missionDetails">{{ t("experiences.mission-details") }}</Label>
          <Textarea id="missionDetails" v-model="newExperience.missionDetails" required/>
        </div>

        <div class="flex flex-row gap-2">
          <Button variant="secondary" @click="$router.back()">{{ t("utils.cancel") }}</Button>
          <Button type="submit">{{ t("utils.create") }}</Button>
        </div>
      </form>
    </div>
  </div>
</template>


