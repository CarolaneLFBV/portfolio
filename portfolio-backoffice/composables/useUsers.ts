import type {User, UserCredentials} from "~/types/user";
import apiHelper from "~/utils/apiHelper";
import {ref} from "vue";

const user = ref<UserCredentials>({
    email: '',
    password: '',
    role: '',
})

export default function () {
    async function getUserBySlug(slug: string) {
        try {
            const response = await apiHelper.kyPrivateGet<User>(`users/${slug}`);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la récupération de l\'utilisateur:', error);
            throw error;
        }
    }

    async function getUsers() {
        try {
            const response = await apiHelper.kyPrivateGet<User[]>('users');
            return response.data;
        } catch (error) {
            console.error(error);
        }
    }

    async function updateUser(user: User) {
        try {
            const response = await apiHelper.kyPrivatePatch<User>(`users/${user.slug}`, user);
            return response.data;
        } catch (error) {
            console.error(error);
        }
    }

    async function deleteUser(slug: string) {
        try {
            const response = await apiHelper.kyPrivateDelete(`users/${slug}`);
            return response;
        } catch (error) {
            console.error(error);
            throw error;
        }
    }

    return {
        user,
        getUserBySlug,
        getUsers,
        updateUser,
        deleteUser
    }
}