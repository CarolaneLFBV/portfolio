<script lang="ts" setup>
import ProfileCard from '@/components/ProfileCard.vue'
import BackgroundCircles from '@/components/app/BackgroundCircles.vue'
import SkillsGrid from '@/components/SkillsGrid.vue'
import AppsGrid from '@/components/AppsGrid.vue'
import {useI18n} from 'vue-i18n'

const {t} = useI18n()
</script>

<template>
  <section class="relative">
    <nav
      class="fixed top-0 z-20 left-0 w-full bg-white/30 backdrop-blur-md shadow-md p-4 flex justify-center gap-6">
      <a class="nav-link" href="#apps">{{ t("navigation.apps") }}</a>
      <a class="nav-link" href="#skills">{{ t("navigation.skills") }}</a>
      <router-link class="nav-link" to="/qa">{{ t("navigation.qa") }}</router-link>
    </nav>

    <BackgroundCircles class="fixed top-0 left-0 w-full h-full z-[-1]"/>
    
    <div class="relative z-10">
      <div class="flex flex-col gap-10 justify-between">
        <ProfileCard/>

        <div id="apps">
          <AppsGrid/>
        </div>

        <div id="skills">
          <SkillsGrid/>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.nav-link {
  color: rgb(55, 65, 81);
  transition: color 0.2s ease-in-out;
}

.nav-link:hover {
  color: rgb(17, 24, 39);
}
</style>
