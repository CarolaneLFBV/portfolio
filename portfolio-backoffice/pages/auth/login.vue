<script lang="ts" setup>
import LoginForm from '~/components/forms/LoginForm.vue'

const {t} = useI18n();
</script>

<template>
  <div class="min-h-screen grid grid-cols-1 lg:grid-cols-2">
    <div class="relative flex flex-col bg-stone-900 text-white p-10">
      <div class="absolute inset-0 bg-stone-900">
        <img
            alt="Image Section"
            class="h-full w-full object-cover"
            src="/public/okeep.png"
        />
      </div>
      <div class="relative z-20 flex items-center text-lg font-medium">
        <span> {{ t('app.name') }} </span>
      </div>
    </div>

    <div class="flex flex-col items-center justify-center p-8">
      <div class="mx-auto flex w-full flex-col justify-center space-y-6 sm:w-[350px]">
        <div class="flex flex-col space-y-2 text-center">
          <h1 class="text-2xl font-semibold tracking-tight">
            {{ t('auth.log-in') }}
          </h1>
          <p class="text-sm text-muted-foreground">
            {{ t('auth.log-in-desc') }}
          </p>
        </div>
        <LoginForm/>
      </div>
    </div>
  </div>
</template>