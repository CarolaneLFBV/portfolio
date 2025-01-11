<script setup lang="ts">
import { useUserStore } from '~/stores/useUserStore';
import { navigateTo } from '#app';
import useUser from '~/composables/useUser'
import { cn } from '~/lib/utils'
import { Label } from '~/components/ui/label'
import { Input } from '~/components/ui/input'

const {userCred} = useUser();
const userStore = useUserStore();

const login = async () => {
  try {
    await userStore.login({
      email: userCred.value.email,
      password: userCred.value.password
    });
    navigateTo('/dashboard');
  } catch (error: any) {
    console.log(error);
  }
};
</script>

<template>
  <div :class="cn('grid gap-6', $attrs.class ?? '')">
    <form @submit.prevent="login">
      <div class="grid gap-2">
        <div class="grid gap-1">
          <p> {{ $t('user.email') }} </p>
          <Label class="sr-only" for="email">
            {{ $t('user.email') }}
          </Label>
          <Input
              id="email"
              placeholder="name@example.com"
              type="email"
              auto-capitalize="none"
              auto-complete="email"
              auto-correct="off"
              v-model="userCred.email"
          />
        </div>
        <div class="grid gap-1">
          <p> {{ $t('user.password') }} </p>
          <Label class="sr-only" for="email">
            {{ $t('user.password') }}
          </Label>
          <Input
              id="password"
              type="password"
              placeholder="*********"
              auto-capitalize="none"
              auto-complete="email"
              auto-correct="off"
              v-model="userCred.password"
          />
        </div>
        <div class="flex flex-col items-center space-y-4">
          <Button type="submit" class="w-full">
            {{ $t('auth.log-in') }}
          </Button>
          <div class="text-sm text-muted-foreground">
            <span>{{ $t('auth.no-account') }}</span>
            <a href="/auth/register" class="ml-1 text-primary hover:underline">
              {{ $t('auth.create-acc') }}
            </a>
          </div>
        </div>
      </div>
    </form>
  </div>
</template>