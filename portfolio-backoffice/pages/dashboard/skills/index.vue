<script lang="ts" setup>
import {ref} from "vue";
import {Tabs, TabsContent} from "~/components/ui/tabs";
import TabsList from "~/components/navigation/TabsList.vue";
import SkillCardList from "~/components/card/SkillCardList.vue";
import SkillCreateForm from "~/components/forms/create/SkillCreateForm.vue";
import SkillUpdateForm from "~/components/forms/update/SkillUpdateForm.vue";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth', 'role'],
});

const isCreate = ref(false);
const isUpdate = ref(false);
const selectedSkillSlug = ref<string | null>(null); // Slug du skill à éditer

const tabs = [
  {value: "technical-skills", label: "Technical Skills"},
  {value: "soft-skills", label: "Soft Skills"},
];

function onOpenCreate() {
  isCreate.value = true;
}

function onEdit(slug: string) {
  isUpdate.value = true;
  selectedSkillSlug.value = slug;
}

function onCancel() {
  isCreate.value = false;
  isUpdate.value = false;
  selectedSkillSlug.value = null;
}
</script>

<template>
  <div class="flex-1 space-y-4 p-8 pt-6">
    <div class="flex items-center justify-between">
      <h2 class="text-3xl font-bold tracking-tight">{{ $t("skills.title") }}</h2>
      <Button v-if="!isCreate && !isUpdate" @click="onOpenCreate">
        {{ $t("skills.new") }}
      </Button>
    </div>

    <Tabs class="space-y-4" default-value="technical-skills">
      <div v-if="!isCreate && !isUpdate">
        <TabsList :tabs="tabs"/>
        <TabsContent class="space-y-4" value="technical-skills">
          <SkillCardList type="technical" @edit="onEdit"/>
        </TabsContent>
        <TabsContent class="space-y-4" value="soft-skills">
          <SkillCardList type="soft" @edit="onEdit"/>
        </TabsContent>
      </div>

      <div v-else-if="isCreate">
        <SkillCreateForm @update:create-skill="onCancel"/>
      </div>

      <div v-else-if="isUpdate">
        <SkillUpdateForm :slug="selectedSkillSlug" @update:update-skill="onCancel"/>
      </div>
    </Tabs>
  </div>
</template>