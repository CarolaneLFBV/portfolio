<script setup lang="ts">
import {useAuthStore} from "~/stores/useAuthStore";
import {useUserStore} from "~/stores/useUserStore";
import {useRouter} from "#vue-router";

const router = useRouter();
const {user} = useAuthStore();
const {getAuthenticatedUser} = useUserStore();

onMounted(async () => {
  await onInit();
})

async function onInit() {
  try {
    await getAuthenticatedUser();
  } catch (error) {
    console.log(error);
    await router.push('/auth/login');
  }
}

function editUser(id: string) {
  router.push(`/users/${id}`);
}

</script>

<template>
  <div v-if="user">
    <div class="card-container text-white">
      <div class="flex flex-row">
        <h3 class="text-violet-light font-semibold"> {{ $t("user.fullName") }}: </h3>
        <p class="ml-1"> {{ user.firstName }} {{ user.lastName }} </p>
      </div>

      <div class="flex flex-row">
        <h3 class="text-violet-light font-semibold"> {{ $t("user.email") }}: </h3>
        <p class="ml-1"> {{ user.email }} </p>
      </div>

      <div class="flex flex-row">
        <h3 class="text-violet-light font-semibold"> {{ $t("user.role") }}: </h3>
        <p class="ml-1"> {{ user.role }} </p>
      </div>

      <div class="text-right">
        <BaseButton @click="editUser(user.id)"> {{ $t("utils.edit") }} </BaseButton>
      </div>
    </div>
  </div>
</template>