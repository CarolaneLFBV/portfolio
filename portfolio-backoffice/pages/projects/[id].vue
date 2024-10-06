<script setup lang="ts">
import EditProjectForm from "~/components/forms/EditProjectForm.vue";

import {definePageMeta} from "#imports";
definePageMeta({
  layout: 'layout-dashboard',
  middleware: 'auth',
})

</script>

<template>
  <EditProjectForm/>
</template>

<style scoped>

</style>