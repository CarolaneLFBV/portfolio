<script lang="ts" setup>
import {cn} from '@/lib/utils';
import {useI18n} from "#imports";

const {t} = useI18n();
</script>

<template>
  <nav :class="cn('flex items-center space-x-4 lg:space-x-6', $attrs.class ?? '')">

    <NuxtLink
        class="text-sm transition-colors hover:text-primary text-gray-400"
        exact
        to="/dashboard"
    >
      {{ t('dashboard.title') }}
    </NuxtLink>

    <NuxtLink
        class="text-sm transition-colors hover:text-primary text-gray-400"
        to="/dashboard/skills"
    >
      {{ t('skills.title') }}
    </NuxtLink>

    <NuxtLink
        class="text-sm transition-colors hover:text-primary text-gray-400"
        to="/dashboard/projects"
    >
      {{ t('projects.title') }}
    </NuxtLink>

    <NuxtLink
        class="text-sm transition-colors hover:text-primary text-gray-400"
        to="/dashboard/experiences"
    >
      {{ t('experiences.title') }}
    </NuxtLink>
  </nav>
</template>

<style lang="scss" scoped>
.router-link-active {
  @apply text-black dark:text-white;
}
</style>