<script lang="ts" setup>
import {Tabs, TabsContent,} from '~/components/ui/tabs'
import TabsList from '~/components/navigation/TabsList.vue'
import ProjectCards from "~/components/list/ProjectCards.vue";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth']
})

const {t} = useI18n();
const tabs = [
  {value: "professional-projects", label: "Professional"},
  {value: "personal-projects", label: "Personal"},
];

const createNewProject = async () => {
  await navigateTo(`/dashboard/projects/create`)
}
</script>

<template>
  <div class="hidden flex-col md:flex">
    <div class="flex-1 space-y-4 p-8 pt-6">
      <div class="flex items-center justify-between space-y-2">
        <h2 class="text-3xl font-bold tracking-tight">{{ t("projects.title") }}</h2>
        <Button @click="createNewProject">
          {{ t("projects.new") }}
        </Button>
      </div>
      <Tabs class="space-y-4" default-value="professional-projects">
        <TabsList :tabs="tabs"/>
        <TabsContent class="space-y-4" value="professional-projects">
          <ProjectCards type="professional"/>
        </TabsContent>
        <TabsContent class="space-y-4" value="personal-projects">
          <ProjectCards type="personal"/>
        </TabsContent>
      </Tabs>
    </div>
  </div>
</template>