<script lang="ts" setup>
import {ref} from "vue";
import useSkills from "~/composables/useSkill";
import useProjects from "~/composables/useProject";
import type {SkillInput} from "~/types/skill";
import {Textarea} from "~/components/ui/textarea";
import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";
import useExperiences from "~/composables/useExperience";
import {navigateTo} from "#app";

const route = useRoute();
const slug = route.params.slug as string;
const {t} = useI18n();

const {getSkillBySlug, updateSkill} = useSkills();
const {getProjects} = useProjects();
const {getExperiences} = useExperiences();

const skill = ref<SkillInput>();
const tagText = ref<string>('');
const projects = ref<Project[]>([]);
const experiences = ref<Experience[]>([]);
const selectedProjectIDs = ref<string[]>([]);
const selectedExperienceIDs = ref<string[]>([]);

let selectedImage: File | null;

const onInit = async () => {
  if (slug) {
    try {
      skill.value = await getSkillBySlug(slug);
      tagText.value = (skill.value.tags || []).join(", ");
      projects.value = await getProjects();
      experiences.value = await getExperiences();
      selectedProjectIDs.value = skill.value.projects || [];
      selectedExperienceIDs.value = skill.value.experiences || [];
    } catch (error) {
      console.error("Erreur lors de la récupération du skill :", error);
    }
  }
}

watch(tagText, (newValue) => {
  skill.value.tags = newValue.split(",").map(tag => tag.trim());
});

onMounted(async () => {
  await onInit();
});

const onSubmit = async () => {
  const formData = new FormData();
  skill.value.projects = selectedProjectIDs.value;
  skill.value.experiences = selectedExperienceIDs.value;

  formData.append('name', skill.value.name);
  formData.append('type', skill.value.type);
  formData.append('tags[]', skill.value.tags);
  formData.append('introduction[definition]', skill.value.introduction.definition);
  formData.append('introduction[context]', skill.value.introduction.context);
  formData.append('history', skill.value.history);

  skill.value.projects.forEach(projectId => {
    formData.append('projects[]', projectId);
  });
  skill.value.experiences.forEach(experienceId => {
    formData.append('experiences[]', experienceId);
  });

  if (selectedImage != null) {
    formData.append('image', selectedImage);
  }
  await updateSkill(slug, formData);
  await navigateTo({path: `/dashboard/skills/`});
};

const uploadImage = (event: Event) => {
  const target = event.target as HTMLInputElement;
  const files = target.files;
  if (!files || !files[0])
    return;
  selectedImage = files[0];
};

const toggleProjectSelection = (projectId: string) => {
  if (selectedProjectIDs.value.includes(projectId)) {
    selectedProjectIDs.value = selectedProjectIDs.value.filter(id => id !== projectId);
  } else {
    selectedProjectIDs.value.push(projectId);
  }
};

const toggleExperienceSelection = (experienceId: string) => {
  if (selectedExperienceIDs.value.includes(experienceId)) {
    selectedExperienceIDs.value = selectedExperienceIDs.value.filter(id => id !== experienceId);
  } else {
    selectedExperienceIDs.value.push(experienceId);
  }
};
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
        <Label for="name">{{ t("skills.name") }}</Label>
        <Input id="name" v-model="skill.name" required/>
      </div>

      <div class="mb-2">
        <Label for="tags">{{ t("skills.tags") }}</Label>
        <Input id="tags" v-model="tagText" required/>
        <p class="text-sm m-1 text-gray-500">{{ t("skills.tags-comma-separation") }}</p>
      </div>

      <div class="mb-2">
        <Label for="type">{{ t("skills.type") }}</Label>
        <Input id="type" v-model="skill.type" :placeholder="skill.type" required/>
      </div>

      <div class="mb-2">
        <Label for="definition">{{ t("skills.definition") }}</Label>
        <Input id="definition" v-model="skill.introduction.definition" required/>
      </div>

      <div class="mb-2">
        <Label for="context">{{ t("skills.context") }}</Label>
        <Textarea id="context" v-model="skill.introduction.context" required/>
      </div>

      <div class="mb-2">
        <Label for="history">{{ t("skills.history") }}</Label>
        <Textarea id="history" v-model="skill.history" required/>
      </div>

      <fieldset v-if="projects.length > 0" class="flex flex-col">
        <Label for="projects">{{ t("projects.title") }}</Label>
        <div class="mb-2 p-2 flex flex-row flex-wrap gap-2">
          <div
              v-for="project in projects"
              :key="project.id"
              class="cursor-pointer"
              @click="toggleProjectSelection(project.id)"
          >
            <Card
                :class="selectedProjectIDs.includes(project.id) ? 'border border-black' : ''"
                class="p-4 cursor-pointer"
            >
              <CardTitle>{{ project.name }}</CardTitle>
            </Card>
          </div>
        </div>
      </fieldset>

      <fieldset v-if="experiences.length > 0" class="flex flex-col">
        <Label for="experiences">{{ t("experiences.title") }}</Label>
        <div class="mb-2 p-2 flex flex-row flex-wrap gap-2">
          <div
              v-for="experience in experiences"
              :key="experience.id"
              class="cursor-pointer"
              @click="toggleExperienceSelection(experience.id)"
          >
            <Card
                :class="{'border-black': selectedExperienceIDs.includes(experience.id)}"
                class="p-4"
            >
              <CardTitle>{{ experience.name }}</CardTitle>
            </Card>
          </div>
        </div>
      </fieldset>

      <div class="mb-4">
        <Label for="image">{{ t("skills.image") }}</Label>
        <Input id="file-input" accept="image/*" type="file" @change="uploadImage"/>
      </div>

      <div class="flex flex-row gap-2">
        <Button variant="secondary" @click="$router.back()">{{ t("utils.cancel") }}</Button>
        <Button type="submit">{{ t("utils.update") }}</Button>
      </div>
    </form>
  </div>
</template>

<style scoped>

</style>