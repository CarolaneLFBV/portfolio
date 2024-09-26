<script setup lang="ts">
import LayoutNav from "~/layouts/LayoutNav.vue";
</script>

<template>
  <div class="full-height flex-row">
    <LayoutNav/>
    <div class="content">
      <slot />
    </div>
  </div>
</template>

<style scoped>
.content {
  margin-left: 250px;
  padding: 20px;
  width: calc(100% - 250px);
}
</style>