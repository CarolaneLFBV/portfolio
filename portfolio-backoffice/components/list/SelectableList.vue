<script lang="ts" setup>
import type {PropType} from 'vue';
import useImage from "~/composables/useImage";
import {DrawingPinIcon} from "@radix-icons/vue";

const props = defineProps({
  title: String,
  items: Array as PropType<{ id: string; name: string }[]>,
  selectedItems: Array as PropType<string[]>,
});
const {getLogo} = useImage()

const emit = defineEmits(['update:selectedItems']);

const toggleSelection = (id: string) => {
  const updatedSelection = props.selectedItems?.includes(id)
      ? props.selectedItems.filter(itemId => itemId !== id)
      : [...(props.selectedItems ?? []), id];
  emit('update:selectedItems', updatedSelection);
};
</script>

<template>
  <fieldset v-if="items && items.length > 0" class="flex flex-col">
    <Label>{{ title }}</Label>
    <div class="mb-2 p-2 flex flex-row flex-wrap gap-2">
      <div
          v-for="item in items"
          :key="item.id"
          class="cursor-pointer"
          @click="toggleSelection(item.id)"
      >
        <Card :class="{'border-black dark:border-white': selectedItems?.includes(item.id)}" class="p-4 cursor-pointer">
          <div class="flex items-center gap-2">
            <DrawingPinIcon/>
            <CardTitle>{{ item.name }}</CardTitle>
          </div>
        </Card>
      </div>
    </div>
  </fieldset>
</template>
