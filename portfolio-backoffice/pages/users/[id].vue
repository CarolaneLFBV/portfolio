<script setup lang="ts">
import {definePageMeta} from "#imports";
import EditUserForm from "~/components/forms/edit/EditUserForm.vue";

definePageMeta({
  layout: 'layout-dashboard',
  middleware: ['auth', 'admin'],
})

</script>

<template>
  <EditUserForm/>
</template>
