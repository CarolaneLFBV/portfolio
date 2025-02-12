<script lang="ts" setup>
import {Tabs, TabsContent} from "~/components/ui/tabs";
import TabsList from "~/components/navigation/TabsList.vue";
import SkillCards from "~/components/list/SkillCards.vue";
import {definePageMeta, useI18n} from "#imports";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth', 'role'],
});

const {t} = useI18n();
const tabs = [
  {value: "technical-skills", label: "Technical Skills"},
  {value: "soft-skills", label: "Soft Skills"},
];

const createNewSkill = async () => {
  await navigateTo({path: '/dashboard/skills/create'})
}

</script>

<template>
  <div class="flex-1 space-y-4 p-8 pt-6">
    <div class="flex items-center justify-between">
      <h2 class="text-3xl font-bold tracking-tight">{{ t("skills.title") }}</h2>
      <Button @click="createNewSkill">
        {{ t("skills.new") }}
      </Button>
    </div>

    <Tabs class="space-y-4" default-value="technical-skills">
      <TabsList :tabs="tabs"/>
      <TabsContent class="space-y-4" value="technical-skills">
        <SkillCards type="technical"/>
      </TabsContent>
      <TabsContent class="space-y-4" value="soft-skills">
        <SkillCards type="soft"/>
      </TabsContent>
    </Tabs>
  </div>
</template>