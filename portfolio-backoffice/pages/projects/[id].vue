<script setup lang="ts">
import EditProjectForm from "~/components/forms/edit/EditProjectForm.vue";
import {definePageMeta} from "#imports";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: ['auth', 'admin'],
})
</script>

<template>
  <EditProjectForm/>
</template>
