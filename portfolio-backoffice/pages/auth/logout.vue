<script lang="ts" setup>
</script>

<template>
  <div class="flex h-screen items-center justify-center">
    <Card>
      <CardHeader>
        <CardTitle>{{ $t('auth.logged-out') }}</CardTitle>
      </CardHeader>
      <CardContent>
        {{ $t('auth.logged-out-desc') }}<a class="ml-1 text-primary hover:underline" href="/">
        {{ $t('auth.log-in') }}
      </a>.
      </CardContent>
    </Card>
  </div>
</template>
