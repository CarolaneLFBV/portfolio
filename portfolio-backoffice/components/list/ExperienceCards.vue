<script lang="ts" setup>
import {computed, onMounted, ref} from "vue";
import useExperience from "~/composables/useExperience";
import ExperienceCard from "~/components/card/ExperienceCard.vue";
import NoDataView from "~/components/dashboard/NoDataView.vue";
import type {Experience} from "~/types/experience";

const props = defineProps<{
  type: "professional" | "education";
}>();

const experiences = ref<Experience[]>([]);
const {getExperiences} = useExperience();
const filteredExperiences = computed(() => {
  return experiences.value.filter(experience => experience.type === props.type);
});

const loadData = async () => {
  try {
    experiences.value = await getExperiences();
  } catch (error) {
    console.error(error);
  }
}

onMounted(async () => {
  await loadData();
});

const removeExperience = (slug: string) => {
  experiences.value = experiences.value.filter(experience => experience.slug !== slug);
};
</script>

<template>
  <ExperienceCard
      v-for="experience in filteredExperiences"
      v-if="filteredExperiences.length"
      :experience="experience"
      @experienceDeleted="removeExperience"
  />
  <div v-if="!filteredExperiences.length">
    <NoDataView/>
  </div>
</template>