<script lang="ts" setup>
import {useUserStore} from '~/stores/useUserStore';
import useUser from '~/composables/useUser'
import {Label} from '~/components/ui/label'
import {Input} from '~/components/ui/input'
import {useI18n} from "#imports";
import {navigateTo} from "#app";
import TypeSelector from "~/components/inputs/TypeSelector.vue";

const {newUser} = useUser();
const userStore = useUserStore();
const {t} = useI18n();

const register = async () => {
  try {
    await userStore.register({
      nickName: newUser.value.nickName,
      email: newUser.value.email,
      password: newUser.value.password,
      role: newUser.value.role,
    });
    await navigateTo({path: `/dashboard`});
  } catch (error: any) {
    console.log(error);
  }
};

</script>

<template>
  <div class="flex items-center justify-center min-h-screen overflow-auto py-10">
    <div class="max-w-4xl w-full mx-auto p-6">
      <h2 class="text-3xl font-bold tracking-tight my-4 text-center">{{ t('user.new') }}</h2>
      <form class="max-w-xl w-3/4 md:w-1/2 mx-auto p-6" @submit.prevent="register">
        <div class="mb-2">
          <Label for="nickname">{{ t('user.nickname') }}</Label>
          <Input
              id="nickname"
              v-model="newUser.nickName"
              placeholder="johndoe"
          />
        </div>

        <div class="mb-2">
          <Label for="email">{{ t('user.email') }}</Label>
          <Input
              id="email"
              v-model="newUser.email"
              auto-complete="email"
              placeholder="johndoe@example.com"
              type="email"
          />
        </div>

        <div class="mb-2">
          <Label for="email">{{ t('user.password') }}</Label>
          <Input
              id="password"
              v-model="newUser.password"
              placeholder="*********"
              type="password"
          />
        </div>

        <div class="mb-2">
          <Label for="role">{{ t('user.role') }}</Label>
          <TypeSelector
              v-model:type="newUser.role"
              option-one="admin"
              option-two="member"
          />
        </div>

        <div class="flex flex-row gap-2">
          <Button variant="secondary" @click="$router.back()">{{ t("utils.cancel") }}</Button>
          <Button type="submit">{{ t('auth.create-acc') }}</Button>
        </div>
      </form>
    </div>
  </div>
</template>