<script setup lang="ts">
import LayoutNav from "~/layouts/LayoutNav.vue";
import LayoutFooter from "~/layouts/LayoutFooter.vue";
</script>

<template>
  <main class="full-height flex-row">
    <LayoutNav/>
    <div class="content">
      <slot />
    </div>
  </main>
</template>

<style scoped>
.content {
  margin-left: 250px;
  padding: 20px;
  width: calc(100% - 250px);
}
</style>