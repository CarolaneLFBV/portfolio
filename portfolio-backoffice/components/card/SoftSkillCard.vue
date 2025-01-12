<script lang="ts" setup>
import {ref} from "vue";
import type {Skill} from "~/types/skill";
import useSkills from "~/composables/useSkills";
import {Pencil2Icon, TrashIcon} from '@radix-icons/vue'

const skills = ref<Skill[]>([]);
const {getSkills} = useSkills()

async function onInit() {
  try {
    skills.value = await getSkills();
  } catch (error) {
    console.error(error);
  }
}

onMounted(async () => {
  await onInit();
})

</script>

<template>
  <div v-if="skills">
    <div v-for="skill in skills" :key="skill.slug" class="p-3">
      <div v-if="skill.type == 'soft'">
        <Card class="flex items-center p-4">
          <CardHeader>
            <img class="w-32 h-32 rounded-md object-cover" src="/public/okeep.png"/>
          </CardHeader>
          <div class="flex flex-col space-y-2">
            <CardTitle class="text-lg font-bold">{{ skill.name }}</CardTitle>
            <CardDescription class="flex flex-wrap gap-2">
              <span
                  v-for="tag in skill.tags"
                  :key="tag"
                  class="inline-block bg-gray-100 px-2 py-1 rounded-lg"
              >
                {{ tag }}
              </span>
            </CardDescription>
            <div class="flex flex-row flex-wrap gap-2 pt-3">
              <Button>
                <Pencil2Icon/>
                {{ $t("utils.edit") }}
              </Button>
              <Button class="bg-red-500">
                <TrashIcon/>
                {{ $t("utils.delete") }}
              </Button>
            </div>
          </div>
        </Card>
      </div>
    </div>
  </div>
</template>


<style scoped>
</style>