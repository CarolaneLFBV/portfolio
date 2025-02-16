<script lang="ts" setup>
import {
  TagsInput,
  TagsInputInput,
  TagsInputItem,
  TagsInputItemDelete,
  TagsInputItemText
} from '@/components/ui/tags-input'

const props = defineProps({
  tags: {
    type: Array as () => string[],
    required: true
  }
});
const emit = defineEmits(["update:tags"]);
const tagsRef = ref<string[]>([...props.tags]);

watch(tagsRef, (newTags) => {
  emit("update:tags", newTags);
}, {deep: true});
</script>

<template>
  <TagsInput v-model="tagsRef">
    <TagsInputItem v-for="item in tagsRef" :key="item" :value="item">
      <TagsInputItemText/>
      <TagsInputItemDelete/>
    </TagsInputItem>

    <TagsInputInput placeholder="Tags..."/>
  </TagsInput>
</template>