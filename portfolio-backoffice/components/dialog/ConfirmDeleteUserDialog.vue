<script lang="ts" setup>
import {useI18n} from "vue-i18n";

const {t} = useI18n();

const props = defineProps({
  title: {
    type: String,
    default: "Delete"
  },
  message: {
    type: String,
    default: "This action cannot be undone. This will permanently delete your account and remove your data from our servers."
  },
  confirmText: {
    type: String,
    default: "Confirm"
  },
  cancelText: {
    type: String,
    default: "Cancel"
  }
});

const computedTitle = computed(() => props.title || t("utils.delete"));
const computedMessage = computed(() => props.message || t("utils.delete-confirmation"));
const computedConfirmText = computed(() => props.confirmText || t("utils.delete"));
const computedCancelText = computed(() => props.cancelText || t("utils.cancel"));

const emit = defineEmits(["confirm", "cancel"]);
</script>

<template>
  <AlertDialog>
    <AlertDialogTrigger as-child>
      <slot name="trigger"></slot>
    </AlertDialogTrigger>

    <AlertDialogContent>
      <AlertDialogHeader>
        <AlertDialogTitle>{{ computedTitle }}</AlertDialogTitle>
        <AlertDialogDescription>{{ computedMessage }}</AlertDialogDescription>
      </AlertDialogHeader>
      <AlertDialogFooter>
        <AlertDialogCancel @click="$emit('cancel')">{{ computedCancelText }}</AlertDialogCancel>
        <AlertDialogAction @click="$emit('confirm')">{{ computedConfirmText }}</AlertDialogAction>
      </AlertDialogFooter>
    </AlertDialogContent>
  </AlertDialog>
</template>