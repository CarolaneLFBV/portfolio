<script lang="ts" setup>
import {Tabs, TabsContent,} from '~/components/ui/tabs'
import TabsList from '~/components/navigation/TabsList.vue'
import ExperienceCards from "~/components/list/ExperienceCards.vue";
import {definePageMeta, useI18n} from "#imports";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth']
})

const {t} = useI18n();
const tabs = [
  {value: "professional-experiences", label: "Professional"},
  {value: "education-experiences", label: "Training"},
];

const createNewExperience = async () => {

}
</script>

<template>
  <div class="flex-1 space-y-4 p-8 pt-6">
    <div class="flex items-center justify-between">
      <h2 class="text-3xl font-bold tracking-tight">{{ t("experiences.title") }}</h2>
      <Button @click="createNewExperience">
        {{ t("experiences.new") }}
      </Button>
    </div>

    <Tabs class="space-y-4" default-value="overview">
      <TabsList :tabs="tabs"/>
      <TabsContent class="space-y-4" value="professional-experiences">
        <ExperienceCards type="professional"/>
      </TabsContent>
      <TabsContent class="space-y-4" value="education-experiences">
        <ExperienceCards type="education"/>
      </TabsContent>
    </Tabs>
  </div>
</template>

