<script lang="ts" setup>
import useUser from "~/composables/useUser";
import {useRoute} from "#vue-router";
import {useI18n} from "#imports";
import type {UserInput} from "~/types/user";
import {navigateTo} from "#app";
import {ref} from "vue";
import LogoInput from "~/components/inputs/LogoInput.vue";
import TypeSelector from "~/components/inputs/TypeSelector.vue";

const route = useRoute()
const slug = route.params.slug as string;
const {t} = useI18n()

const user = ref<UserInput>();
const {getUserBySlug, updateUser} = useUser()
let selectedLogo: File | null;

const onInit = async () => {
  if (slug) {
    try {
      user.value = await getUserBySlug(slug);
    } catch (error) {
      console.error("Erreur lors de la récupération du user :", error);
    }
  }
}

onMounted(async () => {
  await onInit();
})

const onSubmit = async () => {
  const formData = new FormData();
  formData.append("firstName", user.value?.firstName ?? "");
  formData.append("lastName", user.value?.lastName ?? "");
  formData.append("nickName", user.value.nickName);
  formData.append("email", user.value.email);
  formData.append("role", user.value.role);
  formData.append("bio", user.value.bio);

  if (selectedLogo != null) {
    formData.append('image', selectedLogo);
  }

  console.log("USER DATA:", user.value);

  await updateUser(slug, formData)
  await navigateTo({path: `/dashboard`});
}
</script>


<template>
  <div v-if="user" class="flex items-center justify-center min-h-screen overflow-auto py-10">
    <div class="max-w-4xl w-full mx-auto p-6">
      <h2 class="text-3xl font-bold tracking-tight my-4 text-center">
        {{ t("utils.edit") }} {{ user.nickName }}
      </h2>
      <form @submit.prevent="onSubmit">
        <LogoInput v-model:logo="selectedLogo"/>

        <div class="mb-2">
          <Label for="firstname">{{ t("user.firstname") }}</Label>
          <Input id="firstname" v-model="user.firstName"/>
        </div>

        <div class="mb-2">
          <Label for="lastname">{{ t("user.lastname") }}</Label>
          <Input id="lastname" v-model="user.lastName"/>
        </div>

        <div class="mb-2">
          <Label for="nickname">{{ t("user.nickname") }}</Label>
          <Input id="nickname" v-model="user.nickName" required/>
        </div>

        <div class="mb-2">
          <Label for="email">{{ t("user.email") }}</Label>
          <Input id="email" v-model="user.email" required/>
        </div>

        <div class="mb-2">
          <Label for="type">{{ t("user.role") }}</Label>
          <TypeSelector
              v-model:type="user.role"
              optionOne="admin"
              optionTwo="member"
          />
        </div>

        <div class="mb-2">
          <Label for="bio">{{ t("user.bio") }}</Label>
          <Textarea id="bio" v-model="user.bio"/>
        </div>

        <div class="flex flex-row gap-2">
          <Button variant="secondary" @click="$router.back()">{{ t("utils.cancel") }}</Button>
          <Button type="submit">{{ t("utils.update") }}</Button>
        </div>
      </form>
    </div>

  </div>
</template>
