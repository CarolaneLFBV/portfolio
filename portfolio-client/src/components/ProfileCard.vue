<script lang="ts" setup>
import useUser from "@/composables/useUser";
import type {UserInput} from '@/types/user'
import {onMounted, ref} from 'vue'
import SocialLinks from "@/components/SocialLinks.vue";

const user = ref<UserInput>();
const {getUserBySlug} = useUser();

const onInit = async () => {
  try {
    user.value = await getUserBySlug("carolanelefebvre");
  } catch (error) {
    console.error("Erreur lors de la récupération du user :", error);
  }
}

onMounted(async () => {
  await onInit();
})

</script>


<template>
  <section v-if="user">
    <div class="relative flex flex-col items-center justify-center h-screen overflow-hidden">
      <div class="relative z-10 text-center">
        <img
          alt="Logo"
          class="w-40 h-40 rounded-full shadow-lg border-4 border-gray-200 hover:scale-105 transition-transform mx-auto"
          src="/okeep.png"
        />

        <div class="m-1">
          <h1 class="text-5xl font-bold mt-6">{{ user.firstName }} {{ user.lastName }}</h1>
          <h2 class="text-2xl mt-2 text-gray-700">{{ user.bio }}</h2>
          <SocialLinks/>
        </div>
      </div>

      <div class="absolute bottom-40 animate-bounce cursor-pointer">
        <svg class="bi bi-arrow-down-circle text-gray-700" fill="currentColor" height="40"
             viewBox="0 0 16 16"
             width="40" xmlns="http://www.w3.org/2000/svg">
          <path d="M8 1a7 7 0 1 1 0 14A7 7 0 0 1 8 1zm0 1a6 6 0 1 0 0 12A6 6 0 0 0 8 2z"
                fill-rule="evenodd"/>
          <path
            d="M8 4a.5.5 0 0 1 .5.5v5.793l2.146-2.147a.5.5 0 0 1 .708.708l-3 3a.5.5 0 0 1-.708 0l-3-3a.5.5 0 1 1 .708-.708L7.5 10.293V4.5A.5.5 0 0 1 8 4z"
            fill-rule="evenodd"/>
        </svg>
      </div>
    </div>
  </section>
</template>

<style scoped>

</style>
