<script lang="ts" setup>
import {Pencil2Icon, TrashIcon} from "@radix-icons/vue";
import useExperience from "~/composables/useExperience";
import {useI18n} from "#imports";
import type {Experience} from "~/types/experience";
import useImage from "~/composables/useImage";
import ConfirmDeleteDialog from "~/components/dialog/ConfirmDeleteDialog.vue";

const {t} = useI18n();

const emit = defineEmits<{
  (event: 'experienceDeleted', slug: string): void;
}>();

const props = defineProps<{
  experience: Experience;
}>();

const {deleteExperience} = useExperience();
const {getLogo} = useImage()
const experienceToDelete = ref<string | null>(null);

const onDelete = async () => {
  if (experienceToDelete.value) {
    try {
      await deleteExperience(experienceToDelete.value);
      emit("experienceDeleted", experienceToDelete.value);
    } catch (error) {
      console.error(error);
    } finally {
      experienceToDelete.value = null;
    }
  }
}

const editExperience = async () => {
  await navigateTo(`/dashboard/experiences/${props.experience.slug}`)
}
</script>

<template>
  <Card class="flex flex-col items-start space-y-4 p-4">
    <div class="flex items-center space-x-4">
      <CardHeader>
        <img
            :src="`${getLogo(experience.logoUrl)}`"
            alt="Skill Logo"
            class="w-32 h-32 rounded-md object-cover"
        />
      </CardHeader>
      <div class="flex flex-col">
        <CardTitle class="text-lg font-bold">{{ experience.name }}</CardTitle>
        <div class="flex flex-row flex-wrap gap-2 mt-4">
          <Button @click="editExperience">
            <Pencil2Icon/>
            {{ t("utils.update") }}
          </Button>
          <ConfirmDeleteDialog
              :slug="experience.name"
              @cancel="experienceToDelete = null"
              @confirm="onDelete"
          >
            <template #trigger>
              <Button variant="destructive" @click="experienceToDelete = experience.slug">
                <TrashIcon/>
                {{ t("utils.delete") }}
              </Button>
            </template>
          </ConfirmDeleteDialog>
        </div>
      </div>
    </div>
  </Card>
</template>