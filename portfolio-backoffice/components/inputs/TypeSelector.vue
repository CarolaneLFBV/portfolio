<script lang="ts" setup>
import {ref, watch} from "vue";

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
const typeRef = ref(props.type);

watch(() => props.type, (newType) => {
  typeRef.value = newType;
});

watch(typeRef, (newType) => {
  emit("update:type", newType);
});
</script>

<template>
  <Select v-model="typeRef">
    <SelectTrigger>
      <SelectValue :placeholder="typeRef"/>
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