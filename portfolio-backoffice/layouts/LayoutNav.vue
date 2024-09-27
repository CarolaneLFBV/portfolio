<script setup lang="ts">
</script>

<template>
  <nav class="sidebar full-height flex-column flex-row-center">
    <h2 class="flex-align-start">{{ $t("backoffice") }}</h2>
    <ul>
      <li><NuxtLink to="/dashboard" active-class="active-link">{{ $t("dashboard.title") }}</NuxtLink></li>
      <li><NuxtLink to="/projects" active-class="active-link">{{ $t("projects.title") }}</NuxtLink></li>
      <li><NuxtLink to="/skills" active-class="active-link">{{ $t("skills.title") }}</NuxtLink></li>
      <li><NuxtLink to="/experiences" active-class="active-link">{{ $t("experiences.title") }}</NuxtLink></li>
    </ul>
  </nav>
</template>

<style scoped>
.sidebar {
  width: 25rem;
  background-color: var(--secondary-background-color);
  padding: 2rem;
  position: fixed;
}
</style>