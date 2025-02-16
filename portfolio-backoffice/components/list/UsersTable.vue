<script lang="ts" setup>
import {Table, TableBody, TableCell, TableHead, TableHeader, TableRow,} from '@/components/ui/table'
import useUser from "~/composables/useUser";
import {ref} from "vue";
import type {User} from "~/types/user";
import {useI18n} from "#imports";
import {Pencil2Icon, TrashIcon} from "@radix-icons/vue";
import {navigateTo} from "#app";
import ConfirmDeleteUserDialog from "~/components/dialog/ConfirmDeleteUserDialog.vue";
import useImage from "~/composables/useImage";
import NoDataView from "~/components/dashboard/NoDataView.vue";

const {t} = useI18n();
const {getAllUsers, deleteUser} = useUser()
const {getLogo} = useImage();
const users = ref<User[]>([]);

// Deleting User
const isDeletingUser = ref<boolean>(false);
const userToDelete = ref<User | null>(null);
const confirmDelete = (user: User) => {
  isDeletingUser.value = true;
  userToDelete.value = user;
};

const loadData = async () => {
  users.value = await getAllUsers();
}

onMounted(async () => {
  await loadData();
})

const editUser = async (slug: string) => {
  await navigateTo(`/dashboard/users/${slug}`);
};

const onDelete = async () => {
  if (userToDelete.value) {
    await deleteUser(userToDelete.value.slug);
    await loadData();
    userToDelete.value = null;
  }
};

</script>

<template>
  <Table v-if="users.length">
    <TableHeader>
      <TableRow>
        <TableHead>{{ t("user.nickname") }}</TableHead>
        <TableHead>{{ t("user.email") }}</TableHead>
        <TableHead>{{ t("user.role") }}</TableHead>
        <TableHead>{{ t("utils.actions") }}</TableHead>
      </TableRow>
    </TableHeader>
    <TableBody>
      <TableRow v-for="user in users" :key="user.id">
        <TableCell>
          <div class="flex items-center gap-2">
            <img
                :src="`${getLogo(user.imageURL)}`"
                alt="User Logo"
                class="w-10 h-10 rounded-md object-cover"
            />
            {{ user.nickName }}
          </div>
        </TableCell>
        <TableCell>{{ user.email }}</TableCell>
        <TableCell>{{ user.role }}</TableCell>
        <TableCell>
          <div class="flex gap-2">
            <Button @click="editUser(user.slug)">
              <Pencil2Icon/>
            </Button>

            <ConfirmDeleteUserDialog
                :cancelText="t('utils.cancel')"
                :confirmText="t('utils.delete')"
                :message="t('utils.delete-confirmation')"
                :title="t('utils.delete')"
                @cancel="userToDelete = null"
                @confirm="onDelete"
            >
              <template #trigger>
                <Button variant="destructive" @click="confirmDelete(user)">
                  <TrashIcon/>
                </Button>
              </template>
            </ConfirmDeleteUserDialog>
          </div>
        </TableCell>
      </TableRow>
    </TableBody>
  </Table>
  <div v-else>
    <NoDataView/>
  </div>
</template>