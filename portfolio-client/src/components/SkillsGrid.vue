<script setup lang="ts">
import { onMounted, ref } from 'vue'
import type { Skill } from '@/types/skill'
import useSkills from '@/composables/useSkills.ts'
import useImage from '@/composables/useImage.ts'

const skills = ref<Skill[]>([]);
const {getSkills} = useSkills();
const {getLogo} = useImage();

const loadData = async () => {
  try {
    skills.value = await getSkills();
  } catch (error) {
    console.error(error);
  }
}

onMounted(async () => {
  await loadData();
});

const formatSkillName = (name: string) => {
  return name.replace(" ", "\n");
};
</script>

<template>
  <section>
    <h3 class="text-2xl font-bold mb-4">Skills</h3>
    <div class="flex flex-row flex-wrap gap-10">
      <div v-for="skill in skills" :key="skill.id" class="text-center">
        <img
          class="w-16 h-16 mx-auto rounded-2xl object-cover"
          :src="`${getLogo(skill.imageURL)}`"
          alt="App Icon"
        />
        <p class="font-bold mt-2 break-words whitespace-pre-line">{{ formatSkillName(skill.name) }}</p>
      </div>
    </div>
  </section>
</template>

<style scoped>

</style>
