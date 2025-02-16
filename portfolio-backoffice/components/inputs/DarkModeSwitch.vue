<script setup>
import {useColorMode} from "#imports";
import {MoonIcon, SunIcon} from "@radix-icons/vue";

const colorMode = useColorMode();

const toggleDarkMode = () => {
  colorMode.preference = colorMode.preference === "dark" ? "light" : "dark";
};
</script>

<template>
  <button class="p-2 rounded-md transition-all" @click="toggleDarkMode">
    <MoonIcon v-if="colorMode.preference !== 'dark'" class="w-6 h-6 text-gray-900 dark:text-gray-100"/>
    <SunIcon v-else class="w-6 h-6 text-gray-900 dark:text-gray-100"/>
  </button>
</template>