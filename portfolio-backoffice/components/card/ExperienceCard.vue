<script lang="ts" setup>
import {Pencil2Icon, TrashIcon} from "@radix-icons/vue";
import useExperience from "~/composables/useExperience";
import {useI18n} from "#imports";
import type {Experience} from "~/types/experience";

const {t} = useI18n();

const emit = defineEmits<{
  (event: 'experienceDeleted', slug: string): void;
}>();

const props = defineProps<{
  experience: Experience;
}>();

const {deleteExperience, getExperienceImages} = useExperience();

const onDelete = async (slug: string) => {
  try {
    await deleteExperience(slug);
    emit('experienceDeleted', slug);
  } catch (error) {
    console.error(error);
  }
}

const editExperience = async () => {
  await navigateTo(`/dashboard/experiences/${props.experience.slug}`)
}
</script>

<template>
  <Card class="flex flex-col items-start space-y-4 p-4">
    <div class="flex items-center space-x-4">
      <div class="flex flex-col">
        <CardTitle class="text-lg font-bold">{{ experience.name }}</CardTitle>
        <div class="flex flex-row flex-wrap gap-2 mt-4">
          <Button @click="editExperience">
            <Pencil2Icon/>
            {{ t("utils.update") }}
          </Button>
          <Button variant="destructive" @click="onDelete(experience.slug)">
            <TrashIcon/>
            {{ t("utils.delete") }}
          </Button>
        </div>
      </div>
    </div>
  </Card>
</template>