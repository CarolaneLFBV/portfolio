<script lang="ts" setup>
import {cn} from '@/lib/utils'
</script>

<template>
  <nav :class="cn('flex items-center space-x-4 lg:space-x-6', $attrs.class ?? '')">
    <a class="text-sm font-medium transition-colors hover:text-primary"
       href="/dashboard/">
      {{ $t("dashboard.title") }}
    </a>
    <a class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
       href="/dashboard/skills/">
      {{ $t("skill.title") }}
    </a>
    <a class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
       href="/dashboard/projects/">
      {{ $t("project.title") }}
    </a>
    <a class="text-sm font-medium text-muted-foreground transition-colors hover:text-primary"
       href="/dashboard/experiences/">
      {{ $t("experience.title") }}
    </a>
  </nav>
</template>
