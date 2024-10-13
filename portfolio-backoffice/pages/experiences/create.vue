<script setup lang="ts">
import {definePageMeta} from "#imports";
import CreateExperienceForm from "~/components/forms/create/CreateExperienceForm.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: ['auth', 'admin'],
})

</script>

<template>
  <CreateExperienceForm/>
</template>
