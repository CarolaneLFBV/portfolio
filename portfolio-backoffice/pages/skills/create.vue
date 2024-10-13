<script setup lang="ts">
import {definePageMeta} from "#imports";
import CreateSkillForm from "~/components/forms/create/CreateSkillForm.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: ['auth', 'admin'],
})

</script>

<template>
  <CreateSkillForm/>
</template>
