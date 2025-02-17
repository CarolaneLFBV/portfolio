<script lang="ts" setup>
import useUser from "@/composables/useUser";
import type {UserInput } from '@/types/user'
import { onMounted, ref } from 'vue'
import useImage from '@/composables/useImage.ts'
import SocialLinks from '@/components/SocialLinks.vue'

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
        <div class="flex flex-col">
          <h1 class="text-4xl font-bold">{{ user.firstName }} {{ user.lastName }}</h1>
          <h2 class="text-xl">{{ user.bio }}</h2>
          <SocialLinks/>
        </div>
  </section>
</template>

<style scoped>

</style>
