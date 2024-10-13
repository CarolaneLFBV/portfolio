<script setup lang="ts">
import { defineProps, defineEmits, computed } from 'vue';

const props = defineProps({
  type: {
    type: String,
    default: 'button',
  },
  classes: {
    type: String,
    default: 'bg-red hover:bg-red-dark text-white py-2 px-4 mx-2 rounded-lg',
  },
});

const emit = defineEmits(['click']);

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
