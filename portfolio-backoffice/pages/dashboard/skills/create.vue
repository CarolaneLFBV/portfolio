<script lang="ts" setup>
import useSkills from "~/composables/useSkill";
import {Textarea} from "~/components/ui/textarea";
import {navigateTo} from "#app";
import {ref} from "vue";
import {useI18n} from "#imports";

const {t} = useI18n();
const {createSkill, newSkill} = useSkills();
const tagText = ref<string>('');

const onInit = async () => {
  try {
    tagText.value = (newSkill.value.tags || []).join(", ");
  } catch (error) {
    console.error("Erreur lors de la récupération du skill :", error);
  }
}

watch(tagText, (newValue) => {
  newSkill.value.tags = newValue.split(",").map(tag => tag.trim());
});

onMounted(async () => {
  await onInit();
});

const onSubmit = async () => {
  const formData = new FormData();
  formData.append('name', newSkill.value.name);
  formData.append('type', newSkill.value.type);
  formData.append('tags[]', newSkill.value.tags);
  formData.append('introduction[definition]', newSkill.value.introduction.definition);
  formData.append('introduction[context]', newSkill.value.introduction.context);
  formData.append('history', newSkill.value.history);

  await createSkill(formData);
  await navigateTo({path: `/dashboard`});
};

</script>

<template>
  <div class="flex-1 space-y-4 p-8 pt-6">
    <div class="flex items-center justify-between">
      <h2 class="text-3xl font-bold tracking-tight">
        {{ t("skills.new") }}
      </h2>
    </div>
    <form @submit.prevent="onSubmit">
      <div class="mb-2">
        <Label for="name">{{ t("skills.name") }}</Label>
        <Input id="name" v-model="newSkill.name" required/>
      </div>

      <div class="mb-2">
        <Label for="tags">{{ t("skills.tags") }}</Label>
        <Input id="tags" v-model="tagText"/>
      </div>

      <div class="mb-2">
        <Label for="type">{{ t("skills.type") }}</Label>
        <Input id="type" v-model="newSkill.type" required/>
      </div>

      <div class="mb-2">
        <Label for="definition">{{ t("skills.definition") }}</Label>
        <Input id="definition" v-model="newSkill.introduction.definition" required/>
      </div>

      <div class="mb-2">
        <Label for="context">{{ t("skills.context") }}</Label>
        <Textarea id="context" v-model="newSkill.introduction.context" required/>
      </div>

      <div class="mb-4">
        <Label for="history">{{ t("skills.history") }}</Label>
        <Textarea id="history" v-model="newSkill.history" required/>
      </div>

      <div class="flex flex-row gap-2">
        <Button variant="secondary" @click="$router.back()">{{ t("utils.cancel") }}</Button>
        <Button type="submit">{{ t("utils.create") }}</Button>
      </div>
    </form>
  </div>
</template>


