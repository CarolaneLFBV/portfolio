<script lang="ts" setup>
import useUser from "~/composables/useUser";
import type {User} from "~/types/user";
import {navigateTo} from "#app";
import {ref} from "vue";

const route = useRoute()
const slug = route.params.slug as string;
const {t} = useI18n()

const user = ref<User>();
const {getUserBySlug, updateUser} = useUser()
let selectedImage: File | null;

const onInit = async () => {
  if (slug) {
    try {
      user.value = await getUserBySlug(slug)
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
  if (user.value?.firstName) {
    formData.append("firstName", user.value.firstName);
  }
  if (user.value?.lastName) {
    formData.append("lastName", user.value.lastName);
  }
  formData.append("nickName", user.value.nickName);
  formData.append("email", user.value.email);
  formData.append("role", user.value.role);

  if (selectedImage != null) {
    formData.append('image', selectedImage);
  }

  await updateUser(slug, formData)
  await navigateTo({path: `/dashboard`});
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
  <div v-if="user" class="flex-1 space-y-4 p-8 pt-6">
    <div class="flex items-center justify-between">
      <h2 class="text-3xl font-bold tracking-tight">
        {{ t("utils.edit") }} {{ user.nickName }}
      </h2>
    </div>
    <form @submit.prevent="onSubmit">
      <div class="mb-4">
        <Label for="image">{{ t("user.logo") }}</Label>
        <Input id="file-input" accept="image/*" type="file" @change="uploadImage"/>
      </div>

      <div class="mb-2">
        <Label for="name">{{ t("user.firstname") }}</Label>
        <Input id="name" v-model="user.firstName" required/>
      </div>

      <div class="mb-2">
        <Label for="name">{{ t("user.lastname") }}</Label>
        <Input id="name" v-model="user.lastName" required/>
      </div>

      <div class="mb-2">
        <Label for="name">{{ t("user.nickname") }}</Label>
        <Input id="name" v-model="user.nickName" required/>
      </div>

      <div class="mb-2">
        <Label for="type">{{ t("user.email") }}</Label>
        <Input id="type" v-model="user.email" required/>
      </div>

      <div class="mb-2">
        <Label for="type">{{ t("user.role") }}</Label>
        <Select v-model="user.role">
          <SelectTrigger>
            <SelectValue placeholder="Select a role"/>
          </SelectTrigger>
          <SelectContent>
            <SelectGroup>
              <SelectItem value="admin">
                Admin
              </SelectItem>
              <SelectItem value="member">
                Member
              </SelectItem>
            </SelectGroup>
          </SelectContent>
        </Select>
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