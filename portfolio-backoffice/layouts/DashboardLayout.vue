<script lang="ts" setup>
import NavigationLayout from "~/layouts/NavigationLayout.vue";
import UserProfile from "~/components/dashboard/UserProfile.vue";
import FooterLayout from "~/layouts/FooterLayout.vue";
</script>


<template>
  <div class="min-h-screen flex flex-col">
    <div class="border-b">
      <div class="flex h-16 items-center px-4">
        <NavigationLayout class="mx-6"/>
        <div class="ml-auto flex items-center space-x-4">
          <UserProfile/>
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