<script lang="ts" setup>
import SkillCards from "~/components/list/SkillCards.vue";
import {definePageMeta, useI18n} from "#imports";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth', 'role'],
});

const {t} = useI18n();
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
    <SkillCards/>
  </div>
</template>