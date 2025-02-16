<script lang="ts" setup>
import {useI18n} from "vue-i18n";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog';

const {t} = useI18n();

const props = defineProps<{
  slug: string;
}>();

const emit = defineEmits(["confirm", "cancel"]);
</script>

<template>
  <AlertDialog>
    <AlertDialogTrigger as-child>
      <slot name="trigger"></slot>
    </AlertDialogTrigger>

    <AlertDialogContent>
      <AlertDialogHeader>
        <AlertDialogTitle>{{ t("utils.delete") }}</AlertDialogTitle>
        <AlertDialogDescription>
          {{ t("utils.delete-confirmation") }} <strong>{{ slug }}</strong> ?
        </AlertDialogDescription>
      </AlertDialogHeader>
      <AlertDialogFooter>
        <AlertDialogCancel @click="$emit('cancel')">{{ t("utils.cancel") }}</AlertDialogCancel>
        <AlertDialogAction @click="$emit('confirm')">{{ t("utils.delete") }}</AlertDialogAction>
      </AlertDialogFooter>
    </AlertDialogContent>
  </AlertDialog>
</template>