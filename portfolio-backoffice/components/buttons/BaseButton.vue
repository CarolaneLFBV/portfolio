<script setup lang="ts">
import { defineProps, defineEmits, computed } from 'vue';

//Define style and btn's action
const props = defineProps({
  type: {
    type: String,
    default: 'button',
  },
  classes: {
    type: String,
    default: 'bg-violet-dark hover:bg-violet text-white py-2 px-4 mx-2 rounded-lg',
  },
});

// Events to emit actions when clicked
const emit = defineEmits(['click']);

// Calculation of classes dependign on props
const computedClasses = computed(() => props.classes);

function handleClick(event: Event) {
  emit('click', event);
}
</script>


<template>
  <button :class="computedClasses" @click="handleClick">
    <slot />
  </button>
</template>
