<script setup lang="ts">
import {definePageMeta} from "#imports";
import EditSkillForm from "~/components/forms/EditSkillForm.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: ['auth'],
})

</script>

<template>
  <EditSkillForm/>
</template>
