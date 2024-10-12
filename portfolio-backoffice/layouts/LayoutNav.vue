<script setup lang="ts">
</script>

<template>
  <nav class="flex flex-col text-white justify-between bg-background w-60 p-6 fixed h-screen">
    <h1 class="text-2xl">{{ $t("dashboard.title") }}</h1>
    <ul class="text-lg">
      <li><NuxtLink to="/dashboard"    active-class="text-violet font-semibold"> {{ $t("users.title") }}         </NuxtLink></li>
      <li><NuxtLink to="/projects"     active-class="text-violet font-semibold"> {{ $t("projects.title") }}      </NuxtLink></li>
      <li><NuxtLink to="/skills"       active-class="text-violet font-semibold"> {{ $t("skills.title") }}        </NuxtLink></li>
      <li><NuxtLink to="/experiences"  active-class="text-violet font-semibold"> {{ $t("experiences.title") }}   </NuxtLink></li>
    </ul>
    <p>{{ $t("dashboard.bottom-dashboard") }}</p>
  </nav>
</template>