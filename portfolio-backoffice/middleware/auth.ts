import useAuthentication from "~/composables/useAuthentication";

export default defineNuxtRouteMiddleware((to, from) => {
    if (import.meta.client) {
        const token = sessionStorage.getItem("token");
        const {tokenExpired, removeToken} = useAuthentication();
        if (!token || tokenExpired(token)) {
            removeToken();
            return navigateTo('/');
        }
    }
})