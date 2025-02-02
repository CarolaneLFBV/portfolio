<script lang="ts" setup>
import {ref} from "vue";
import useSkills from "~/composables/useSkills";
import useProjects from "~/composables/useProjects";
import type {SkillInput} from "~/types/skill";
import {Textarea} from "~/components/ui/textarea";
import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";
import useExperiences from "~/composables/useExperiences";
import {Checkbox} from "~/components/ui/checkbox";

const emit = defineEmits<{
  (_e: 'update:update-skill', _value: boolean): void,
}>();

const props = defineProps<{
  slug: string | null;
}>()
const {getSkillBySlug, updateSkill} = useSkills();
const {getProjects} = useProjects();
const {getExperiences} = useExperiences();
// Skill
const skill = ref<SkillInput>();
// Projects and Experiences
const projects = ref<Project[]>([]);
const experiences = ref<Experience[]>([]);
const selectedProjectIDs = ref([]);
const selectedExperienceIDs = ref([]);
// Image
let selectedImage: File | null;

const onInit = async () => {
  if (props.slug) {
    try {
      skill.value = await getSkillBySlug(props.slug);
      projects.value = await getProjects();
      experiences.value = await getExperiences();
    } catch (error) {
      console.error("Erreur lors de la récupération du skill :", error);
    }
  }
}

onMounted(async () => {
  await onInit();
});

const onSubmit = async () => {
  const formData = new FormData();
  const skillJson = JSON.stringify(skill.value);
  formData.append('skill', skillJson);
  if (selectedImage != null) {
    formData.append('file', selectedImage);
  }
  await updateSkill(props.slug!, formData);
  emit('update:update-skill', false);
};

const cancel = () => {
  emit('update:update-skill', false);
}

const uploadImage = (event: Event) => {
  const target = event.target as HTMLInputElement;
  const files = target.files;
  if (!files || !files[0])
    return;
  selectedImage = files[0];
};

</script>

<template>
  <div v-if="skill" class="flex-1 space-y-4 p-8 pt-6">
    <div class="flex items-center justify-between">
      <h2 class="text-3xl font-bold tracking-tight">
        {{ skill.name }}
      </h2>
    </div>
    <form id="skillForm" @submit.prevent="onSubmit">
      <div class="mb-2">
        <Label for="name">Name</Label>
        <Input id="name" v-model="skill.name" required/>
      </div>

      <div class="mb-2">
        <Label for="tags">Tags</Label>
        <Input id="tags" v-model="skill.tags" required/>
      </div>

      <div class="mb-2">
        <Label for="type">Type</Label>
        <Input id="type" v-model="skill.type" :placeholder="skill.type" required/>
      </div>

      <div class="mb-2">
        <Label for="definition">Definition</Label>
        <Input id="definition" v-model="skill.introduction.definition" required/>
      </div>

      <div class="mb-2">
        <Label class="text-opacity-50 text-sm mb-1" for="context">Context</Label>
        <Textarea id="context" v-model="skill.introduction.context" required/>
      </div>

      <div class="mb-2">
        <Label class="text-opacity-50 text-sm mb-1" for="history">History</Label>
        <Textarea id="history" v-model="skill.history" required/>
      </div>

      <fieldset class="flex flex-row justify-around">
        <legend class="p-0.5 ml-2">{{ $t("projects.title") }}</legend>
        <div class="grid grid-cols-2 gap-4 mb-2 ">
          <div v-for="project in projects" :key="project.id" class="flex flex-row items-center">
            <Checkbox v-model="selectedProjectIDs" :value="project.id" class="rounded text-pink" type="checkbox"/>
            <Label class="ml-1">{{ project.name }}</Label>
          </div>
        </div>
      </fieldset>

      <fieldset class="flex flex-row justify-around">
        <legend class="p-0.5 ml-2">{{ $t("experiences.title") }}</legend>
        <div class="grid grid-cols-2 gap-4 mb-2 ">
          <div v-for="exp in experiences" :key="exp.id" class="flex flex-row items-center">
            <Card>

            </Card>
            <Checkbox v-model="selectedExperienceIDs" :value="exp.id" class="rounded text-pink" type="checkbox"/>
            <Label class="ml-1">{{ exp.name }}</Label>
          </div>
        </div>
      </fieldset>

      <div class="mb-4">
        <Label class="text-opacity-50 text-sm mb-1" for="image">Image</Label>
        <Input id="file-input" accept="image/*" type="file" @change="uploadImage"/>
      </div>
      <div class="flex flex-row gap-2">
        <Button variant="secondary" @click="cancel">{{ $t("utils.cancel") }}</Button>
        <Button type="submit">{{ $t("utils.update") }}</Button>
      </div>
    </form>
  </div>
</template>