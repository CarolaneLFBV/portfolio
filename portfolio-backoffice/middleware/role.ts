import useAuthentication from "~/composables/useAuthentication";

export default defineNuxtRouteMiddleware((to, from) => {
    if (import.meta.client) {
        const { isAdmin } = useAuthentication();
        const jwt = sessionStorage.getItem('jwt') ;
        if (!isAdmin(jwt)) {
            return navigateTo('/error/not-found');
        }
    }
});