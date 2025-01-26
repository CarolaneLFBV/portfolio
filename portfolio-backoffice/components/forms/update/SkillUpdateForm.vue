<script lang="ts" setup>
import {ref} from "vue";
import useSkills from "~/composables/useSkills";
import type {SkillInput} from "~/types/skill";
import {Textarea} from "~/components/ui/textarea";
import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";

const {getSkillBySlug, updateSkill} = useSkills();
const skill = ref<SkillInput>();
const projects = ref<Project[]>([]);
const experiences = ref<Experience[]>([]);
const selectedProjectIDs = ref([]);
const selectedExperienceIDs = ref([]);
const selectedImage = ref<File | null>(null);

const emit = defineEmits<{
  (_e: 'update:update-skill', _value: boolean): void,
}>();

const props = defineProps<{
  slug: string | null;
}>()

function cancel() {
  emit('update:update-skill', false);
}

async function onInit() {
  if (props.slug) {
    try {
      skill.value = await getSkillBySlug(props.slug);
      if (Array.isArray(skill.value.tags)) {
        skill.value.tags = skill.value.tags.join(", ");
      }
    } catch (error) {
      console.error("Erreur lors de la récupération du skill :", error);
    }
  }
}

onMounted(async () => {
  await onInit();
});

async function onSubmit() {
  try {
    const formData = new FormData();
    formData.append("name", skill.value.name);
    formData.append("type", skill.value.type);

    const tagsArray = Array.isArray(skill.value.tags)
        ? skill.value.tags
        : skill.value.tags.split(',').map(tag => tag.trim());

    tagsArray.forEach(tag => formData.append("tags[]", tag));

    formData.append("introduction[definition]", skill.value.introduction.definition || "");
    formData.append("introduction[context]", skill.value.introduction.context || "");
    formData.append("history", skill.value.history || "");
    formData.append("projects", JSON.stringify(selectedProjectIDs.value));
    formData.append("experiences", JSON.stringify(selectedExperienceIDs.value));

    if (selectedImage.value) {
      formData.append("image", selectedImage.value);
    }

    await updateSkill(props.slug!, formData);
    emit('update:update-skill', false);
  } catch (error) {
    console.error("Error creating skill:", error);
  }
}
</script>

<template>
  <div v-if="skill" class="flex-1 space-y-4 p-8 pt-6">
    <div class="flex items-center justify-between">
      <h2 class="text-3xl font-bold tracking-tight">
        {{ skill.name }}
      </h2>
    </div>
    <form @submit.prevent="onSubmit">
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

      <div class="mb-2">
        <Label class="text-opacity-50 text-sm mb-1" for="history">Image</Label>
        <Input
            id="image"
            accept="image/*"
            type="file"
            @change="e => selectedImage.value = e.target.files[0]"
        />
        <div v-if="skill.image && !selectedImage.value" class="mt-2">
          <p class="text-sm text-gray-500">Image actuelle :</p>
          <img :src="skill.image" alt="Current Skill Image" class="w-32 h-32 rounded-md object-cover"/>
        </div>
      </div>

    </form>
    <div class="flex flex-row gap-2">
      <Button variant="secondary" @click="cancel()">{{ $t("utils.cancel") }}</Button>
      <Button @click="onSubmit()">{{ $t("utils.update") }}</Button>
    </div>
  </div>
</template>


