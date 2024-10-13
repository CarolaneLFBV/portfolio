import { useAuthStore } from '~/stores/useAuthStore';
import useAuthentication from '~/composables/useAuthentication';

export default defineNuxtRouteMiddleware((to, from) => {
    if (import.meta.client) {
        const { tokenExpired } = useAuthentication();
        const jwt = sessionStorage.getItem('jwt');
        if (!jwt || tokenExpired(jwt)) {
            const authStore = useAuthStore();
            authStore.logOut();
            return navigateTo('/disconnect');
        }
    }
});
