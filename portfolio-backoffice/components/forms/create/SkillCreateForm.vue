<script lang="ts" setup>
import useSkills from "~/composables/useSkills";
import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";
import {Textarea} from "~/components/ui/textarea";
import type {SkillInput} from "~/types/skill";

const emit = defineEmits<{
  (_e: 'update:create-skill', _value: boolean): void,
}>();

// Skill
const newSkill = ref<SkillInput>({
  image: undefined,
  name: '',
  type: 'technical',
  tags: [],
  introduction: {definition: '', context: ''},
  history: '',
  projects: [],
  experiences: [],
});
const {createSkill} = useSkills();
// Projects and Experiences
const projects = ref<Project[]>([]);
const experiences = ref<Experience[]>([]);
const selectedProjectIDs = ref([]);
const selectedExperienceIDs = ref([]);
// Image
const selectedImage = ref<File | null>(null);

const onSubmit = async () => {
  newSkill.value.tags = newSkill.value.tags.split(',');
  await createSkill(newSkill.value);
  emit('update:create-skill', false);
}

const cancel = () => {
  emit('update:create-skill', false);
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
        <Input id="tags" v-model="newSkill.tags"/>
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

      <div class="mb-4">
        <Label class="text-opacity-50 text-sm mb-1" for="history">History</Label>
        <Textarea id="history" v-model="newSkill.history" required/>
      </div>

      <div class="flex flex-row gap-2">
        <Button variant="secondary" @click="cancel">{{ $t("utils.cancel") }}</Button>
        <Button type="submit">{{ $t("utils.create") }}</Button>
      </div>
    </form>
  </div>
</template>


