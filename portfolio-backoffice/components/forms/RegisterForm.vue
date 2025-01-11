<script lang="ts" setup>
import {useUserStore} from '~/stores/useUserStore';
import useUser from '~/composables/useUser'
import {cn} from '~/lib/utils'
import {Label} from '~/components/ui/label'
import {Input} from '~/components/ui/input'

const {userCred} = useUser();
const userStore = useUserStore();

const register = async () => {
  try {
    await userStore.register({
      nickName: userCred.value.nickName,
      email: userCred.value.email,
      password: userCred.value.password,
      role: 'member'
    });
  } catch (error: any) {
    console.log(error);
  }
};
</script>

<template>
  <div :class="cn('grid gap-6', $attrs.class ?? '')">
    <form @submit.prevent="register">
      <div class="grid gap-2">
        <div class="grid gap-1">
          <p> {{ $t('user.nickname') }} </p>
          <Label class="sr-only">
            {{ $t('user.nickname') }}
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
          <p> {{ $t('user.email') }} </p>
          <Label class="sr-only" for="email">
            {{ $t('user.email') }}
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
          <p> {{ $t('user.password') }} </p>
          <Label class="sr-only" for="email">
            {{ $t('user.password') }}
          </Label>
          <Input
              id="password"
              v-model="userCred.password"
              auto-capitalize="none"
              auto-complete="email"
              auto-correct="off"
              placeholder="*********"
              type="password"
          />
        </div>
        <div class="flex flex-col items-center space-y-4">
          <Button class="w-full" type="submit">
            {{ $t('auth.create-acc') }}
          </Button>
          <div class="text-sm text-muted-foreground">
            <span>{{ $t('auth.already-acc') }}</span>
            <a class="ml-1 text-primary hover:underline" href="/">
              {{ $t('auth.log-in') }}
            </a>
          </div>
        </div>
      </div>
    </form>
  </div>
</template>