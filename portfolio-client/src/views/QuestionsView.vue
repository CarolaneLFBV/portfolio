<script lang="ts" setup>
import BackgroundCircles from '@/components/app/BackgroundCircles.vue'
import {useI18n} from 'vue-i18n'

const {t} = useI18n()
</script>

<template>
  <section class="relative">
    <nav
      class="fixed top-0 z-20 left-0 w-full bg-white/30 backdrop-blur-md shadow-md p-4 flex justify-center gap-6">
      <router-link class="nav-link" to="/#apps">{{ t("navigation.apps") }}</router-link>
      <router-link class="nav-link" to="/#skills">{{ t("navigation.skills") }}</router-link>
      <router-link class="nav-link" to="/qa">{{ t("navigation.qa") }}</router-link>
    </nav>

    <BackgroundCircles class="fixed top-0 left-0 w-full h-full z-[-1]"/>
    <div class="relative z-10">
      <div class="relative z-10 flex items-start mt-10 p-10">
        <div class="flex flex-col gap-10 justify-between">
          <div>
            <h2 class="text-2xl font-bold mb-2">{{ t("qa.who-am-i") }}</h2>
            <p>{{ t("qa.who-am-i-response") }}</p>
          </div>

          <div>
            <h2 class="text-2xl font-bold mb-2">{{ t("qa.tech-stacks") }}</h2>
            <p>{{ t("qa.tech-stacks-response") }}</p>
            <ul class="list-disc">
              <li class="m-2"><span class="font-bold">{{ t("tech.mobile") }}</span>
                {{ t("qa.tech-stacks-mobile") }}
              </li>
              <li class="m-2"><span class="font-bold">{{ t("tech.web") }}</span>
                {{ t("qa.tech-stacks-web") }}
              </li>
              <li class="m-2"><span class="font-bold">{{ t("tech.backend") }}</span>
                {{ t("qa.tech-stacks-backend") }}
              </li>
              <li class="m-2"><span class="font-bold">{{ t("tech.tools-devops") }}</span>
                {{ t("qa.tech-stacks-tools-and-devops") }}
              </li>
              <li class="m-2"><span class="font-bold">{{ t("tech.project-management") }}</span>
                {{ t("qa.tech-stacks-project-management") }}
              </li>
            </ul>
          </div>

          <div>
            <h2 class="text-2xl font-bold mb-2">{{ t("qa.tech-stacks-preferred") }}</h2>
            <p>{{ t("qa.tech-stacks-preferred-response") }}</p>
          </div>

          <div>
            <h2 class="text-2xl font-bold mb-2">{{ t("qa.professional-exp") }}</h2>
            <p>{{ t("qa.professional-exp-response") }}</p>
            <div class="flex flex-row gap-5 flex-wrap">
              <a class="bg-black p-2 mt-2 rounded-full flex items-center w-auto justify-center"
                 href="https://www.linkedin.com/in/carolane-lefebvre/">
                <i class="pi pi-linkedin" style="color: white"></i>
                <p class="text-white pl-3">{{ t("qa.linkedin") }}</p>
              </a>
              <a
                class="text-white bg-black p-2 mt-2 rounded-full flex items-center w-auto justify-center"
                href="/resume.pdf"
                target="_blank">
                {{ t("qa.download") }}
              </a>
            </div>
          </div>

          <div>
            <h2 class="text-2xl font-bold mb-2">{{ t("qa.freelance") }}</h2>
            <p>{{ t("qa.freelance-response") }}</p>
          </div>

          <div>
            <h2 class="text-2xl font-bold mb-2">{{ t("qa.english") }}</h2>
            <p>{{ t("qa.english-response") }}</p>
          </div>

          <div>
            <h2 class="text-2xl font-bold mb-2">{{ t("qa.soft-skills") }}</h2>
            <p>{{ t("qa.soft-skills-response") }}</p>
          </div>
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
