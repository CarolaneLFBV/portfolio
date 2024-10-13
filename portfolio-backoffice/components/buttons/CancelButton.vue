<script setup lang="ts">
import { defineProps, computed } from 'vue';

const props = defineProps({
  type: {
    type: String,
    default: 'button',
  },
  classes: {
    type: String,
    default: 'bg-pink hover:bg-pink-dark text-white py-2 px-4 mx-2 rounded-lg',
  },
});

const computedClasses = computed(() => props.classes);

function handleClick() {
  navigateTo('/dashboard');
}
</script>


<template>
  <button :class="computedClasses" @click="handleClick">
    {{ $t("utils.cancel") }}
  </button>
</template>
