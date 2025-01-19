<script lang="ts" setup>
import {computed, onMounted, ref} from "vue";
import type {Skill} from "~/types/skill";
import useSkills from "~/composables/useSkills";
import {Pencil2Icon, TrashIcon} from "@radix-icons/vue";

const props = defineProps<{
  type: "technical" | "soft";
}>();

const skills = ref<Skill[]>([]);
const {getSkills, deleteSkill} = useSkills();

const filteredSkills = computed(() => {
  return skills.value.filter(skill => skill.type === props.type);
});

async function loadData() {
  try {
    skills.value = await getSkills();
  } catch (error) {
    console.error(error);
  }
}

onMounted(async () => {
  await loadData();
});

async function onDelete(slug: string) {
  try {
    await deleteSkill(slug);
    await loadData();
  } catch (error) {
    console.error(error);
  }
}
</script>

<template>
  <div v-if="filteredSkills.length">
    <div v-for="skill in filteredSkills" :key="skill.slug" class="p-3">
      <Card class="flex flex-col items-start space-y-4 p-4">
        <div class="flex items-center space-x-4">
          <CardHeader>
            <img class="w-32 h-32 rounded-md object-cover" src="/public/okeep.png"/>
          </CardHeader>
          <div class="flex flex-col">
            <CardTitle class="text-lg font-bold">{{ skill.name }}</CardTitle>
            <CardDescription>
              <span
                  v-for="tag in skill.tags"
                  :key="tag"
                  class="inline-block mr-2 bg-gray-100 px-2 py-1 rounded-lg"
              >
                {{ tag }}
              </span>
            </CardDescription>
            <div class="flex flex-row gap-2 mt-4">
              <Button @click="$emit('edit', skill.slug)">
                <Pencil2Icon/>
                {{ $t("utils.update") }}
              </Button>
              <Button variant="destructive" @click="onDelete(skill.slug)">
                <TrashIcon/>
                {{ $t("utils.delete") }}
              </Button>
            </div>
          </div>
        </div>
      </Card>
    </div>
  </div>
  <div v-else>
    <p class="text-center text-gray-500">{{ $t("skills.none") }}</p>
  </div>
</template>