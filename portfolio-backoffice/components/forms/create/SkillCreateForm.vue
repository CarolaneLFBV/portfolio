<script lang="ts" setup>
import useSkills from "~/composables/useSkills";
import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";
import {Textarea} from "~/components/ui/textarea";

const emit = defineEmits<{
  (_e: 'update:create-skill', _value: boolean): void,
}>();

function cancel() {
  emit('update:create-skill', false);
}

const {createSkill, newSkill} = useSkills();
const projects = ref<Project[]>([]);
const experiences = ref<Experience[]>([]);
const selectedProjectIDs = ref([]);
const selectedExperienceIDs = ref([]);
const selectedImage = ref<File | null>(null);

async function onSubmit() {
  try {
    const formData = new FormData();
    formData.append("name", newSkill.value.name);
    formData.append("type", newSkill.value.type);

    const tagsArray = newSkill.value.tags.split(',').map(tag => tag.trim());
    tagsArray.forEach(tag => formData.append("tags[]", tag));

    formData.append("introduction[definition]", newSkill.value.introduction.definition || "");
    formData.append("introduction[context]", newSkill.value.introduction.context || "");
    formData.append("history", newSkill.value.history || "");
    formData.append("projects", JSON.stringify(selectedProjectIDs.value));
    formData.append("experiences", JSON.stringify(selectedExperienceIDs.value));

    await createSkill(formData);
    emit('update:create-skill', false);
  } catch (error) {
    console.error("Error creating skill:", error);
  }
}
</script>

<template>
  <div class="flex-1 space-y-4 p-8 pt-6">
    <div class="flex items-center justify-between">
      <h2 class="text-3xl font-bold tracking-tight">
        {{ $t("skills.new") }}
      </h2>
    </div>
    <form @submit.prevent="onSubmit">
      <div class="mb-2">
        <Label for="name">Name</Label>
        <Input id="name" v-model="newSkill.name" required/>
      </div>

      <div class="mb-2">
        <Label for="tags">Tags</Label>
        <Input id="tags" v-model="newSkill.tags" required/>
      </div>

      <div class="mb-2">
        <Label for="type">Type</Label>
        <Input id="type" v-model="newSkill.type" required/>
      </div>

      <div class="mb-2">
        <Label for="definition">Definition</Label>
        <Input id="definition" v-model="newSkill.introduction.definition" required/>
      </div>

      <div class="mb-2">
        <Label class="text-opacity-50 text-sm mb-1" for="context">Context</Label>
        <Textarea id="context" v-model="newSkill.introduction.context" required/>
      </div>

      <div class="mb-2">
        <Label class="text-opacity-50 text-sm mb-1" for="history">History</Label>
        <Textarea id="history" v-model="newSkill.history" required/>
      </div>
    </form>
    <div class="flex flex-row gap-2">
      <Button variant="secondary" @click="cancel()">{{ $t("utils.cancel") }}</Button>
      <Button @click="onSubmit()">{{ $t("utils.create") }}</Button>
    </div>
  </div>
</template>


