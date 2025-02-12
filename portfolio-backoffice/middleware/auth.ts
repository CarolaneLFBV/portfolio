import useAuthentication from '~/composables/useAuthentication';

export default defineNuxtRouteMiddleware((to, from) => {
    if (import.meta.client) {
        const {tokenExpired, removeToken} = useAuthentication();
        const jwt = sessionStorage.getItem('jwt');
        if (!jwt || tokenExpired(jwt)) {
            removeToken();
            return navigateTo('/auth/logout');
        }
    }
});
