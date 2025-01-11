import useAuthentication from '~/composables/useAuthentication';

export default defineNuxtRouteMiddleware((to, from) => {
    if (import.meta.client) {
        const { tokenExpired } = useAuthentication();
        const jwt = sessionStorage.getItem('jwt');
        if (!jwt || tokenExpired(jwt)) {
            return navigateTo('/auth/logout');
        }
    }
});
