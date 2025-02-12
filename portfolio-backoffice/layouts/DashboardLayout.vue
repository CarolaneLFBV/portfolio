<script lang="ts" setup>
import NavigationLayout from "~/layouts/NavigationLayout.vue";
import FooterLayout from "~/layouts/FooterLayout.vue";
import {Button} from "~/components/ui/button";
import {useUserStore} from "~/stores/useUserStore";
import {useI18n} from "#imports";

const {t} = useI18n();
const {logout} = useUserStore()
const logoutUser = async () => {
  await logout();
}
</script>


<template>
  <div class="min-h-screen flex flex-col">
    <div class="border-b">
      <div class="flex h-16 items-center px-4">
        <NavigationLayout class="mx-6"/>
        <div class="ml-auto flex items-center space-x-4">
          <Button variant="secondary" @click="logoutUser()">{{ t('auth.log-out') }}</Button>
        </div>
      </div>
    </div>

    <main class="flex-1">
      <NuxtPage/>
    </main>

    <FooterLayout/>
  </div>
</template>

<style scoped>

</style>