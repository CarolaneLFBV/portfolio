<script setup lang="ts">
import {definePageMeta} from "#imports";
import EditUserForm from "~/components/forms/EditUserForm.vue";

definePageMeta({
  title: 'Edit',
  middleware: ['auth'],
})

</script>

<template>
  <EditUserForm/>
</template>
