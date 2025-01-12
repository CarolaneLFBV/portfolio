<script lang="ts" setup>
import useSkills from "~/composables/useSkills";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth', 'role']
})

const emit = defineEmits<{
  (_e: 'update:create-skill', _value: boolean): void,
}>()

function cancel() {
  emit('update:create-skill', false);
}

const {createSkill, newSkill} = useSkills();
const projects = ref<Project[]>([]);
const experiences = ref<Experience[]>([]);
const selectedProjectIDs = ref([]);
const selectedExperienceIDs = ref([]);

async function onSubmit() {
  try {
    newSkill.value.tags = newSkill.value.tags.split(',').map(tag => tag.trim());
    newSkill.value.projects = selectedProjectIDs.value;
    newSkill.value.experiences = selectedExperienceIDs.value;
    await createSkill(newSkill.value);
    await navigateTo('skills');
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
      <div class="flex flex-col mb-2">
        <Label class="text-opacity-50 text-sm mb-1" for="name">Name</Label>
        <Input id="name" v-model="newSkill.name" class="form-input rounded-lg" required/>
      </div>

      <div class="flex flex-col mb-2">
        <Label class="text-opacity-50 text-sm mb-1" for="tags">Tags</Label>
        <Input id="tags" v-model="newSkill.tags" class="form-input rounded-lg" required/>
      </div>

      <div class="flex flex-col mb-2">
        <Label class="text-opacity-50 text-sm mb-1" for="tags">Type</Label>
        <Input id="tags" v-model="newSkill.type" class="form-input rounded-lg" required/>
      </div>

      <div class="flex flex-col mb-2">
        <label class="text-opacity-50 text-sm mb-1" for="definition">Definition</label>
        <Input id="definition" v-model="newSkill.introduction.definition" class="form-input rounded-lg" required/>
      </div>

      <div class="flex flex-col mb-2">
        <Label class="text-opacity-50 text-sm mb-1" for="context">Context</Label>
        <Input id="context" v-model="newSkill.introduction.context" class="form-input rounded-lg" required/>
      </div>

      <div class="flex flex-col mb-2">
        <Label class="text-opacity-50 text-sm mb-1" for="history">History</Label>
        <textarea id="history" v-model="newSkill.history" class="form-input rounded-lg" required/>
      </div>

      <div class="flex flex-col mb-2">
        <Label class="text-opacity-50 text-sm mb-1" for="images">Images</Label>
        <Input accept="image/*" type="file" @change=""/>
      </div>

      <Button>{{ $t("utils.create") }}</Button>
    </form>
    <Button @click="cancel()">{{ $t("utils.cancel") }}</Button>
  </div>
</template>



