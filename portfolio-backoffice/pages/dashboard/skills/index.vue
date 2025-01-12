<script lang="ts" setup>
import {Tabs, TabsContent} from '~/components/ui/tabs';
import TabsList from '~/components/navigation/TabsList.vue';
import {PlusIcon} from '@radix-icons/vue';
import SkillCreateForm from '~/components/forms/create/SkillCreateForm.vue';
import TechnicalSkillCard from "~/components/card/TechnicalSkillCard.vue";
import SoftSkillCard from "~/components/card/SoftSkillCard.vue";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth'],
});

const isCreate = ref<boolean>(false);

const tabs = [
  {value: 'technical-skills', label: 'Technical Skills'},
  {value: 'soft-skills', label: 'Soft Skills'},
];

async function onOpenCreate() {
  try {
    isCreate.value = true;
  } catch (e) {
    console.error(e);
  }
}
</script>

<template>
  <div class="flex-1 space-y-4 p-8 pt-6">
    <div class="flex items-center justify-between">
      <h2 class="text-3xl font-bold tracking-tight">
        {{ $t('skills.title') }}
      </h2>
      <Button @click="onOpenCreate">
        <PlusIcon/>
        {{ $t('skills.new') }}
      </Button>
    </div>
    <Tabs class="space-y-4" default-value="technical-skills">
      <div v-if="!isCreate">
        <TabsList :tabs="tabs"/>
        <TabsContent class="space-y-4" value="technical-skills">
          <TechnicalSkillCard/>
        </TabsContent>

        <TabsContent class="space-y-4" value="soft-skills">
          <SoftSkillCard/>
        </TabsContent>
      </div>

      <div v-else>
        <SkillCreateForm v-model:create-skill="isCreate"/>
      </div>
    </Tabs>
  </div>
</template>