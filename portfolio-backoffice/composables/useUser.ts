import type {UserCredentials} from '~/types/user'
import {$fetch} from "ofetch";

export default function () {
    const newUser = ref<UserCredentials>({
        nickName: '',
        email: '',
        password: '',
        role: ''
    })

    const config = useRuntimeConfig();
    const apiBaseUrl = config.public.apiBaseUrl;
    const tokenStorage = sessionStorage.getItem("jwt");

    async function getAllUsers() {
        try {
            return await $fetch(`${apiBaseUrl}/users`, {
                method: 'GET',
            });
        } catch (error) {
            console.error('Erreur lors de la récupération des utilisateurs:', error);
            throw error;
        }
    }

    async function getCurrentUser() {
        try {
            return await $fetch(`${apiBaseUrl}/users/current`, {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`,
                }
            });
        } catch (error) {
            console.error("Failed to fetch current user:", error);
            return null;
        }
    }

    async function getUserBySlug(slug: string) {
        try {
            return await $fetch(`${apiBaseUrl}/users/${slug}`, {
                method: 'GET',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`,
                }
            })
        } catch (error) {
            console.error("Failed to fetch user:", error);
            return null;
        }
    }

    async function updateUser(slug: string, user: FormData) {
        try {
            return await $fetch(`${apiBaseUrl}/users/${slug}`, {
                method: 'PATCH',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`
                },
                body: user,
            })
        } catch (error) {
            console.error('Error updating skill', error);
        }
    }

    async function deleteUser(slug: string) {
        try {
            return await $fetch(`${apiBaseUrl}/users/${slug}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`,
                }
            });
        } catch (error) {
            console.error("Failed to fetch current user:", error);
            return null;
        }
    }

    return {
        newUser,
        getAllUsers,
        getCurrentUser,
        deleteUser,
        getUserBySlug,
        updateUser
    }
}