<script lang="ts" setup>

const props = defineProps({
  type: {
    type: String,
    required: true
  },
  optionOne: {
    type: String,
    default: "professional"
  },
  optionTwo: {
    type: String,
    default: "personal"
  }
});
const emit = defineEmits(["update:type"]);
const typeRef = ref<string>(props.type);

watch(typeRef, (newType) => {
  emit("update:type", newType);
});
</script>

<template>
  <Select v-model="typeRef">
    <SelectTrigger>
      <SelectValue placeholder="Select a type"/>
    </SelectTrigger>
    <SelectContent>
      <SelectGroup>
        <SelectItem :value="props.optionOne">
          {{ props.optionOne }}
        </SelectItem>
        <SelectItem :value="props.optionTwo">
          {{ props.optionTwo }}
        </SelectItem>
      </SelectGroup>
    </SelectContent>
  </Select>
</template>