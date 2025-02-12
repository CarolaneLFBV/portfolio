<script lang="ts" setup>
const {t} = useI18n();
</script>

<template>
  <div class="min-h-screen grid grid-cols-1 lg:grid-cols-2">
    <div class="relative flex flex-col bg-stone-900 text-white p-10">
      <div class="absolute inset-0 bg-stone-900">
        <img
            alt="Brand / Image Section"
            class="h-full w-full object-cover"
            src="/public/okeep.png"
        />
      </div>
      <div class="relative z-20 flex items-center text-lg font-medium">
        <span> {{ t('app.name') }} </span>
      </div>
    </div>

    <div class="flex flex-col justify-center">
      <div class="mx-auto flex flex-col w-full justify-center sm:w-[350px]">
        <h1 class="text-3xl">{{ t('auth.logged-out') }}</h1>
        <p class="mb-4">{{ t('auth.logged-out-desc') }}</p>
        <Button>
          <NuxtLink to="/">{{ t('auth.log-in') }}</NuxtLink>
        </Button>
      </div>
    </div>
  </div>
</template>
