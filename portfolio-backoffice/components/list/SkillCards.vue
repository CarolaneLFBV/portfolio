<script lang="ts" setup>
import {onMounted, ref} from "vue";
import type {Skill} from "~/types/skill";
import useSkills from "~/composables/useSkill";
import SkillCard from "~/components/card/SkillCard.vue";
import NoDataView from "~/components/dashboard/NoDataView.vue";

const skills = ref<Skill[]>([]);
const {getSkills} = useSkills();

const loadData = async () => {
  try {
    skills.value = await getSkills();
  } catch (error) {
    console.error(error);
  }
}

onMounted(async () => {
  await loadData();
});

const removeSkill = (slug: string) => {
  skills.value = skills.value.filter(skill => skill.slug !== slug);
};
</script>

<template>
  <SkillCard
      v-for="skill in skills"
      v-if="skills.length"
      :skill="skill"
      @skillDeleted="removeSkill"
  />
  <div v-else>
    <NoDataView/>
  </div>
</template>