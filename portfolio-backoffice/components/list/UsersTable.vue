<script lang="ts" setup>
import {Table, TableBody, TableCell, TableHead, TableHeader, TableRow,} from '@/components/ui/table'
import useUser from "~/composables/useUser";
import {ref} from "vue";
import type {User} from "~/types/user";
import {useI18n} from "#imports";
import {Pencil2Icon, TrashIcon} from "@radix-icons/vue";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
  AlertDialogTrigger,
} from '@/components/ui/alert-dialog'
import {navigateTo} from "#app";

const {t} = useI18n();
const {getAllUsers, deleteUser, getUserImage} = useUser()
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
  <Table>
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
                :src="`${getUserImage(user.imageURL)}`"
                alt="Skill Logo"
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

            <AlertDialog>
              <AlertDialogTrigger as-child>
                <Button variant="destructive" @click="confirmDelete(user)">
                  <TrashIcon/>
                </Button>
              </AlertDialogTrigger>

              <AlertDialogContent>
                <AlertDialogHeader>
                  <AlertDialogTitle>{{ t("utils.delete") }}</AlertDialogTitle>
                  <AlertDialogDescription>
                    {{ t("utils.delete-confirmation") }}
                  </AlertDialogDescription>
                </AlertDialogHeader>
                <AlertDialogFooter>
                  <AlertDialogCancel @click="userToDelete = null">{{ t("utils.cancel") }}</AlertDialogCancel>
                  <AlertDialogAction @click="onDelete">{{ t("utils.delete") }}</AlertDialogAction>
                </AlertDialogFooter>
              </AlertDialogContent>
            </AlertDialog>
          </div>
        </TableCell>
      </TableRow>
    </TableBody>
  </Table>
</template>