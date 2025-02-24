<script setup lang="ts">
import { ref, onMounted } from 'vue';
import type { Circle } from '@/types/circle';

const circles = ref<Circle[]>([]);
const numCircles = 15;

const generateCircles = () => {
  circles.value = Array.from({ length: numCircles }, (_, id) => ({
    id,
    size: Math.random() * 300 + 150,
    top: Math.random() * 150,
    left: Math.random() * 110
  }));
};

onMounted(generateCircles);
</script>

<template>
  <div class="fixed inset-0 pointer-events-none z-[-1]">
    <div v-for="circle in circles" :key="circle.id"
         class="absolute rounded-full bg-gradient-to-br from-blue-500 via-purple-400 to-red-400 opacity-40 blur-[150px]"
         :style="{
           width: `${circle.size}px`,
           height: `${circle.size}px`,
           top: `${circle.top}vh`,
           left: `${circle.left}vw`
         }">
    </div>
  </div>
</template>

<style scoped>
div.fixed {
  width: 100vw;
  height: 300vh;
}
</style>
