<script lang="ts" setup>
import type {Skill} from "~/types/skill";
import {Pencil2Icon, TrashIcon} from "@radix-icons/vue";
import useSkills from "~/composables/useSkill";
import {useI18n} from "#imports";
import useImage from "~/composables/useImage";
import ConfirmDeleteDialog from "~/components/dialog/ConfirmDeleteDialog.vue";

const {t} = useI18n();

const emit = defineEmits<{
  (event: 'skillDeleted', slug: string): void;
}>();
const props = defineProps<{
  skill: Skill;
}>();

const {deleteSkill} = useSkills();
const {getLogo} = useImage()
const skillToDelete = ref<string | null>(null);

const onDelete = async () => {
  if (skillToDelete.value) {
    try {
      await deleteSkill(skillToDelete.value);
      emit('skillDeleted', skillToDelete.value);
    } catch (error) {
      console.error(error);
    } finally {
      skillToDelete.value = null;
    }
  }
}

const editSkill = async () => {
  await navigateTo(`/dashboard/skills/${props.skill.slug}`)
}
</script>

<template>
  <Card class="flex flex-col items-start space-y-4 p-4">
    <div class="flex items-center space-x-4">
      <CardHeader>
        <img
            :src="`${getLogo(skill.imageURL)}`"
            alt="Skill Logo"
            class="w-32 h-32 rounded-md object-cover"
        />
      </CardHeader>
      <div class="flex flex-col">
        <CardTitle class="text-lg font-bold">{{ skill.name }}</CardTitle>
        <CardDescription>
          <span
              v-for="tag in skill.tags"
              :key="tag"
              class="inline-block mr-2 bg-gray-100 px-2 py-1 rounded-lg"
          >
            {{ tag }}
          </span>
        </CardDescription>
        <div class="flex flex-row flex-wrap gap-2 mt-4">
          <Button @click="editSkill">
            <Pencil2Icon/>
            {{ t("utils.update") }}
          </Button>
          <ConfirmDeleteDialog
              :slug="skill.name"
              @cancel="skillToDelete = null"
              @confirm="onDelete"
          >
            <template #trigger>
              <Button variant="destructive" @click="skillToDelete = skill.slug">
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