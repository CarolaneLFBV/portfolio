<script setup lang="ts">
</script>

<template>
  <nav class="sidebar flex-column flex-row-center flex-space-between">
    <h1 class="flex-align-start">{{ $t("dashboard.title") }}</h1>
    <ul>
      <li><NuxtLink to="/dashboard" active-class="active-link">{{ $t("users.title") }}</NuxtLink></li>
      <li><NuxtLink to="/projects" active-class="active-link">{{ $t("projects.title") }}</NuxtLink></li>
      <li><NuxtLink to="/skills" active-class="active-link">{{ $t("skills.title") }}</NuxtLink></li>
      <li><NuxtLink to="/experiences" active-class="active-link">{{ $t("experiences.title") }}</NuxtLink></li>
    </ul>
    <p>{{ $t("dashboard.bottom-dashboard") }}</p>
  </nav>
</template>

<style scoped>
.sidebar {
  width: 25rem;
  background-color: var(--secondary-background-color);
  padding: 2rem;
  position: fixed;
  height: 100%;
}
</style>