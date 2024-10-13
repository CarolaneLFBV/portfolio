<script setup lang="ts">
import {definePageMeta} from "#imports";
import CreateProjectForm from "~/components/forms/create/CreateProjectForm.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: ['auth', 'admin'],
})

</script>

<template>
  <CreateProjectForm/>
</template>
