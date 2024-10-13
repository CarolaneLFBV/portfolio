<script setup lang="ts">
import EditExperienceForm from "~/components/forms/edit/EditExperienceForm.vue";
import {definePageMeta} from "#imports";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: ['auth', 'admin'],
}) 
</script>

<template>
  <EditExperienceForm/>
</template>