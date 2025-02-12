<script lang="ts" setup>
import {useUserStore} from '~/stores/useUserStore';
import useUser from '~/composables/useUser'
import {Label} from '~/components/ui/label'
import {Input} from '~/components/ui/input'
import {useI18n} from "#imports";
import {navigateTo} from "#app";

const {userCred} = useUser();
const userStore = useUserStore();
const {t} = useI18n();

const register = async () => {
  try {
    await userStore.register({
      nickName: userCred.value.nickName,
      email: userCred.value.email,
      password: userCred.value.password,
      role: userCred.value.role,
    });
    await navigateTo({path: `/dashboard`});
  } catch (error: any) {
    console.log(error);
  }
};

</script>

<template>
  <div class="flex items-center justify-center h-screen">
    <form class="max-w-xl w-3/4 md:w-1/2 mx-auto p-6" @submit.prevent="register">
      <div class="grid gap-2">
        <div class="grid gap-1">
          <p> {{ t('user.nickname') }} </p>
          <Label class="sr-only">
            {{ t('user.nickname') }}
          </Label>
          <Input
              id="nickname"
              v-model="userCred.nickName"
              auto-capitalize="none"
              auto-correct="off"
              placeholder="johndoe"
          />
        </div>
        <div class="grid gap-1">
          <p> {{ t('user.email') }} </p>
          <Label class="sr-only" for="email">
            {{ t('user.email') }}
          </Label>
          <Input
              id="email"
              v-model="userCred.email"
              auto-capitalize="none"
              auto-complete="email"
              auto-correct="off"
              placeholder="name@example.com"
              type="email"
          />
        </div>
        <div class="grid gap-1">
          <p> {{ t('user.password') }} </p>
          <Label class="sr-only" for="email">
            {{ t('user.password') }}
          </Label>
          <Input
              id="password"
              v-model="userCred.password"
              auto-capitalize="none"
              auto-correct="off"
              placeholder="*********"
              type="password"
          />
        </div>
        <div class="grid gap-1">
          <p> {{ t('user.role') }} </p>
          <Label class="sr-only" for="email">
            {{ t('user.role') }}
          </Label>
          <Select v-model="userCred.role">
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
          <Button type="submit">{{ t('auth.create-acc') }}</Button>
        </div>
      </div>
    </form>
  </div>
</template>