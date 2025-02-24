<script lang="ts" setup>
import {onMounted, ref} from 'vue'
import type {Project} from '@/types/project'
import useImage from '@/composables/useImage.ts'
import useApps from '@/composables/useApps.ts'
import {useI18n} from "vue-i18n";

const apps = ref<Project[]>([]);
const {getApps} = useApps();
const {getLogo} = useImage();
const {t} = useI18n();

const loadData = async () => {
  try {
    apps.value = await getApps();
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
    <h2 class="text-4xl font-bold mb-6">{{ t("navigation.apps") }}</h2>
    <div class="flex flex-row flex-wrap justify-center gap-2">
      <div class="flex flex-row flex-wrap gap-5">
        <a
          v-for="app in apps"
          :key="app.id"
          :href="app.link"
          class="text-center p-4"
          rel="noopener noreferrer"
          target="_blank">
          <img
            :src="`${getLogo(app.logoUrl)}`"
            alt="App Icon"
            class="w-16 h-16 object-cover mx-auto rounded-2xl"
          />
          <p class="font-bold mt-2 break-words whitespace-pre-line">{{
              formatSkillName(app.name)
            }}</p>
        </a>
      </div>
    </div>
  </div>
</template>

<style scoped>

</style>
