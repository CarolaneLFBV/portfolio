<script lang="ts" setup>
import {onMounted, ref} from 'vue'
import type {Skill} from '@/types/skill'
import useSkills from '@/composables/useSkills.ts'
import useImage from '@/composables/useImage.ts'
import {useI18n} from "vue-i18n";

const skills = ref<Skill[]>([]);
const {getSkills} = useSkills();
const {getLogo} = useImage();
const {t} = useI18n();

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
  <div class="text-center pb-20">
    <h2 class="text-4xl font-bold mb-6">{{ t("navigation.skills") }}</h2>
    <div class="flex flex-row flex-wrap justify-center gap-2">
      <div class="flex flex-row flex-wrap justify-center gap-5">
        <a
          v-for="skill in skills"
          :key="skill.id"
          class="text-center p-4"
          rel="noopener noreferrer"
          target="_blank">
          <img
            :src="`${getLogo(skill.imageURL)}`"
            alt="App Icon"
            class="w-16 h-16 object-cover mx-auto rounded-2xl"
          />
          <p class="font-bold mt-2 break-words whitespace-pre-line">{{
              formatSkillName(skill.name)
            }}</p>
        </a>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
