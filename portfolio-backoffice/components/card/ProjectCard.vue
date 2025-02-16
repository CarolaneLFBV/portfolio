<script lang="ts" setup>
import {Pencil2Icon, TrashIcon} from "@radix-icons/vue";
import useProject from "~/composables/useProject";
import {useI18n} from "#imports";
import useImage from "~/composables/useImage";
import ConfirmDeleteDialog from "~/components/dialog/ConfirmDeleteDialog.vue";
import type {Project} from "~/types/project";

const {t} = useI18n();

const emit = defineEmits<{
  (event: 'projectDeleted', slug: string): void;
}>();

const props = defineProps<{
  project: Project;
}>();

const {deleteProject} = useProject();
const {getLogo} = useImage()
const projectToDelete = ref<string | null>(null);

const onDelete = async () => {
  if (projectToDelete.value) {
    try {
      await deleteProject(projectToDelete.value);
      emit("projectDeleted", projectToDelete.value);
    } catch (error) {
      console.error(error);
    } finally {
      projectToDelete.value = null;
    }
  }
}

const editProject = async () => {
  await navigateTo(`/dashboard/projects/${props.project.slug}`)
}
</script>

<template>
  <Card class="flex flex-col items-start space-y-4 p-4">
    <div class="flex items-center space-x-4">
      <CardHeader>
        <img
            :src="`${getLogo(project.logoUrl)}`"
            alt="Skill Logo"
            class="w-32 h-32 rounded-md object-cover"
        />
      </CardHeader>
      <div class="flex flex-col">
        <CardTitle class="text-lg font-bold">{{ project.name }}</CardTitle>
        <div class="flex flex-row flex-wrap gap-2 mt-4">
          <Button @click="editProject">
            <Pencil2Icon/>
            {{ t("utils.update") }}
          </Button>
          <ConfirmDeleteDialog
              :slug="project.name"
              @cancel="projectToDelete = null"
              @confirm="onDelete"
          >
            <template #trigger>
              <Button variant="destructive" @click="projectToDelete = project.slug">
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