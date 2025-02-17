<template>
  <div class="relative min-h-screen w-full overflow-hidden bg-white">
    <nav class="fixed top-0 z-20 left-0 w-full bg-white/30 backdrop-blur-md shadow-md p-4 flex justify-center gap-6">
      <a href="#apps" class="nav-link">{{ t("navigation.apps") }}</a>
      <a href="#skills" class="nav-link">{{ t("navigation.skills") }}</a>
      <router-link to="/qa" class="nav-link">{{ t("navigation.qa") }}</router-link>
    </nav>

    <BackgroundCircles />
    <div class="relative z-10 flex items-start mt-10 p-10">
      <div class="flex flex-col gap-10 justify-between">
          <ProfileCard />

        <div id="apps">
          <AppsGrid />
        </div>

        <div id="skills">
          <SkillsGrid />
        </div>

      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import ProfileCard from '@/components/ProfileCard.vue'
import BackgroundCircles from '@/components/App/BackgroundCircles.vue'
import SkillsGrid from '@/components/SkillsGrid.vue'
import AppsGrid from '@/components/AppsGrid.vue'
import { useI18n } from 'vue-i18n'

const {t} = useI18n()
</script>

<style scoped>
.nav-link {
  color: rgb(55, 65, 81);
  transition: color 0.2s ease-in-out;
}

.nav-link:hover {
  color: rgb(17, 24, 39);
}
</style>
