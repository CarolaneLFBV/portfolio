<script setup lang="ts">
import BaseButton from "~/components/buttons/BaseButton.vue";
import useProjects from "~/composables/useProjects";
import useSkills from "~/composables/useSkills";
import {ref} from "vue";
import type {Project} from "~/types/project";
import CancelButton from "~/components/buttons/CancelButton.vue";
import type {Experience} from "~/types/experience";
import useExperiences from "~/composables/useExperiences";

const { getProjects } = useProjects();
const { getExperiences } = useExperiences();
const { createSkill, newSkill } = useSkills();
const projects = ref<Project[]>([]);
const experiences = ref<Experience[]>([]);
const selectedProjectIDs = ref([]);
const selectedExperienceIDs = ref([]);
const selectedImage = ref<File | null>(null);

onMounted(async () => {
  await onInit();
});

async function onInit() {
  try {
    projects.value = await getProjects();
    experiences.value = await getExperiences();
  } catch (error) {
    console.error(error);
  }
}

function handleFileChange(event: Event) {
  const file = (event.target as HTMLInputElement).files?.[0];
  if (file) {
    newSkill.value.image = file;
  }
}

async function onSubmit() {
  try {
    await createSkill(newSkill.value);
    await navigateTo("/skills");
  } catch (error) {
    console.error("Error creating skill:", error);
  }
}
</script>

<template>
  <div class="flex flex-col">
    <div class="card-container items-center">
      <h1 class="text-center">{{ $t("skills.new") }}</h1>
        <div>
          <form @submit.prevent="onSubmit">
            <input v-model="newSkill.name" placeholder="Skill Name" required />
            <input v-model="newSkill.tags" placeholder="Tags (comma-separated)" />

            <!-- Introduction -->
            <input v-model="newSkill.introduction.definition" placeholder="Definition" />
            <input v-model="newSkill.introduction.context" placeholder="Context" />

            <!-- History -->
            <textarea v-model="newSkill.history" placeholder="History"></textarea>

            <!-- Image Upload -->
            <input type="file" @change="handleFileChange" accept="image/*" />

            <button type="submit">Create Skill</button>
          </form>
        </div>
    </div>
  </div>
</template>

<style scoped>

</style>