import { defineStore } from 'pinia';
import apiHelper from '~/utils/apiHelper';
import { useAuthStore } from '~/stores/useAuthStore';
import type {UserStore} from "~/types/user";

export const useUserStore = defineStore('userStore', {
    state: (): UserStore => ({
        user: undefined
    }),
    actions: {
        async register(email: string, password: string, isAdmin: boolean): Promise<void> {
            try {
                const authStore = useAuthStore();
                const response = await apiHelper.kyPublicPost<{ token: string }>('auth/register', {
                    email,
                    password,
                    isAdmin,
                });
                authStore.setToken(response.token);
                this.user = { email };
                console.log('Inscription réussie, token:', response.token);
            } catch (error) {
                console.error('Erreur lors de l’inscription:', error);
            }
        },

        async login(email: string, password: string) {
            try {
                const authStore = useAuthStore();
                const response = await apiHelper.kyPublicPost<{ token: string }>('auth/login', {
                    email,
                    password
                });
                authStore.setToken(response.token)
                this.user = { email };
                console.log('Connexion réussie');
            } catch (error) {
                console.error('Erreur lors de la connexion:', error);
            }
        },

        async logout() {
            const authStore = useAuthStore();
            authStore.clearToken();
            this.user = null;
            console.log('Déconnexion réussie');
        },
    }
});
