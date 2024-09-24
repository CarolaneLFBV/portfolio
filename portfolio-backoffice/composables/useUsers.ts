import type {User, UserRegister} from "~/types/user";
import apiHelper from "~/utils/apiHelper";
import {ref} from "vue";

const user = ref<UserRegister>({
    email: '',
    password: '',
    role: '',
})

export default function () {
    async function getUserById(userID: string) {
        try {
            const response = await apiHelper.kyPrivateGet<User>(`users/${userID}`);
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
            const response = await apiHelper.kyPrivatePatch<User>(`users/${user.id}`, user);
            return response.data;
        } catch (error) {
            console.error(error);
        }
    }

    return {
        user,
        getUserById,
        getUsers,
        updateUser,
    }
}