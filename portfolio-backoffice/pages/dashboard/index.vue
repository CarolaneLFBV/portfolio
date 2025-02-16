<script lang="ts" setup>
import {Tabs, TabsContent} from '~/components/ui/tabs'
import TabsList from '~/components/navigation/TabsList.vue'
import {definePageMeta, useI18n} from "#imports";
import {onMounted, ref} from "vue";
import useUser from '~/composables/useUser';
import UsersTable from "~/components/list/UsersTable.vue";

definePageMeta({
  layout: 'dashboard-layout',
  middleware: ['auth']
});

const {t} = useI18n();
const {getCurrentUser} = useUser();

const userRole = ref<string | null>(null);
const tabs = ref([
  {value: "analytics", label: "Analytics"},
]);

const onInit = async () => {
  const currentUser = await getCurrentUser();
  userRole.value = currentUser?.role || null;
  if (userRole.value === 'admin') {
    tabs.value.push({value: "users", label: "Users"});
  }
};

onMounted(async () => {
  await onInit();
});

const createNewUser = async () => {
  await navigateTo({path: '/dashboard/users/create'})
}
</script>

<template>
  <div class="flex-1 space-y-4 p-8 pt-6">
    <div class="flex items-center justify-between space-y-2">
      <h2 class="text-3xl font-bold tracking-tight">
        {{ t("dashboard.title") }}
      </h2>
    </div>
    <Tabs class="space-y-4" default-value="analytics">
      <TabsList :tabs="tabs"/>
      <TabsContent class="space-y-4" value="analytics">
      </TabsContent>

      <TabsContent
          v-if="userRole === 'admin'"
          class="space-y-4"
          value="users"
      >
        <div class="flex-1 space-y-4">
          <UsersTable/>
          <Button @click="createNewUser">
            {{ t("user.new") }}
          </Button>
        </div>
      </TabsContent>
      
    </Tabs>
  </div>
</template>