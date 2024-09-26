<template>
  <nav class="sidebar flex-column full-height justify-center">
    <ul>
      <li><NuxtLink to="/dashboard" active-class="active-link">Dashboard</NuxtLink></li>
      <li><NuxtLink to="/projects" active-class="active-link">Projects</NuxtLink></li>
      <li><NuxtLink to="/skills" active-class="active-link">Services</NuxtLink></li>
      <li><NuxtLink to="/experiences" active-class="active-link">Contact</NuxtLink></li>
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