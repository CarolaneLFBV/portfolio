<script setup lang="ts">
import { ref, onMounted } from 'vue';
import type { Circle } from '@/types/circle';

const circles = ref<Circle[]>([]);
const numCircles = 10;

const generateCircles = () => {
  circles.value = Array.from({ length: numCircles }, (_, id) => ({
    id,
    size: Math.random() * 150 + 100,
    top: Math.random() * 100,
    left: Math.random() * 100
  }));
};

onMounted(generateCircles);
</script>

<template>
  <div class="absolute inset-0 overflow-hidden">
    <div v-for="circle in circles" :key="circle.id"
         class="absolute rounded-full bg-gradient-to-br from-blue-500 via-purple-400 to-red-400 opacity-70 blur-2xl"
         :style="{
        width: `${circle.size}px`,
        height: `${circle.size}px`,
        top: `${circle.top}%`,
        left: `${circle.left}%`
      }">
    </div>
  </div>
</template>

<style scoped>

</style>
