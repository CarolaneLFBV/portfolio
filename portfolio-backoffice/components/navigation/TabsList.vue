<script lang="ts" setup>
import {TabsList as BaseTabsList, TabsTrigger as BaseTabsTrigger} from "~/components/ui/tabs";

const props = defineProps<{
  tabs: TabItem[];
}>();
</script>

<template>
  <BaseTabsList>
    <BaseTabsTrigger
        v-for="tab in tabs"
        :key="tab.value"
        :value="tab.value"
    >
      {{ tab.label }}
    </BaseTabsTrigger>
  </BaseTabsList>
</template>