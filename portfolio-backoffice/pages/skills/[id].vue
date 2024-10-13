<script setup lang="ts">
import {definePageMeta} from "#imports";
import EditSkillForm from "~/components/forms/edit/EditSkillForm.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: ['auth', 'admin'],
})

</script>

<template>
  <EditSkillForm/>
</template>
