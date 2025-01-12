<script lang="ts" setup>
import {Tabs,} from '~/components/ui/tabs'
import TabsList from '~/components/navigation/TabsList.vue'

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth']
})

const tabs = [
  {value: "training", label: "Training"},
  {value: "professional", label: "Professional"},
];
</script>

<template>
  <div class="hidden flex-col md:flex">
    <div class="flex-1 space-y-4 p-8 pt-6">
      <div class="flex items-center justify-between space-y-2">
        <h2 class="text-3xl font-bold tracking-tight">
          {{ $t("dashboard.title") }}
        </h2>
      </div>
      <Tabs class="space-y-4" default-value="overview">
        <TabsList :tabs="tabs"/>
      </Tabs>
    </div>
  </div>
</template>