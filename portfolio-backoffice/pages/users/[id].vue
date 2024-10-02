<script setup lang="ts">
import {definePageMeta} from "#imports";
import EditUserForm from "~/components/forms/EditUserForm.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: ['auth'],
})

</script>

<template>
  <EditUserForm/>
</template>
