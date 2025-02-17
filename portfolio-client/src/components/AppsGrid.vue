<script setup lang="ts">
import { onMounted, ref } from 'vue'
import type { Project } from '@/types/project'
import useImage from '@/composables/useImage.ts'
import useApps from '@/composables/useApps.ts'

const apps = ref<Project[]>([]);
const {getApps} = useApps();
const {getLogo} = useImage();

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
  <section>
    <h3 class="text-2xl font-bold mb-4">Apps</h3>
    <div class="flex flex-row flex-wrap gap-5">
      <a
        v-for="app in apps"
        :key="app.id"
        :href="app.link"
        target="_blank"
        rel="noopener noreferrer"
        class="text-center">
        <img
          class="w-16 h-16 object-cover mx-auto rounded-2xl"
          :src="`${getLogo(app.logoUrl)}`"
          alt="App Icon"
        />
        <p class="font-bold mt-2 break-words whitespace-pre-line">{{ formatSkillName(app.name) }}</p>
      </a>
    </div>
  </section>
</template>

<style scoped>

</style>
