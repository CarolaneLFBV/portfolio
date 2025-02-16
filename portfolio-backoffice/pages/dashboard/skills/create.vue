<script lang="ts" setup>
import useSkills from "~/composables/useSkill";
import {Textarea} from "~/components/ui/textarea";
import {navigateTo} from "#app";
import {useI18n} from "#imports";
import TypeSelector from "~/components/inputs/TypeSelector.vue";
import TagsInput from "~/components/inputs/TagsInput.vue";

const {t} = useI18n();
const {createSkill, newSkill} = useSkills();

const onSubmit = async () => {
  const formData = new FormData();
  formData.append('name', newSkill.value.name);
  formData.append('type', newSkill.value.type);
  newSkill.value.tags.forEach(tag => formData.append('tags[]', tag));
  formData.append('introduction[definition]', newSkill.value.introduction.definition);
  formData.append('introduction[context]', newSkill.value.introduction.context);
  formData.append('history', newSkill.value.history);

  await createSkill(formData);
  await navigateTo({path: `/dashboard/skills`});
};

</script>

<template>
  <div class="flex items-center justify-center min-h-screen overflow-auto py-10">
    <div class="max-w-4xl w-full mx-auto p-6">
      <h2 class="text-3xl font-bold tracking-tight my-4 text-center">
        {{ t("skills.new") }}
      </h2>
      <form @submit.prevent="onSubmit">
        <div class="mb-2">
          <Label for="name">{{ t("skills.name") }}</Label>
          <Input id="name" v-model="newSkill.name" required/>
        </div>

        <div class="mb-2">
          <Label for="tags">{{ t("skills.tags") }}</Label>
          <TagsInput v-model:tags="newSkill.tags"/>
        </div>

        <div class="mb-2">
          <Label for="type">{{ t("skills.type") }}</Label>
          <TypeSelector
              v-model:type="newSkill.type"
              option-one="technical"
              option-two="soft"
          />
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
  </div>
</template>


