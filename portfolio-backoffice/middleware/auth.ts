import useAuthentication from "~/composables/useAuthentication";

export default defineNuxtRouteMiddleware((to, from) => {
    if (import.meta.client) {
        const token = sessionStorage.getItem("token");
        const {tokenExpired} = useAuthentication();
        if (!token || tokenExpired(token)) {
            return navigateTo('/auth/login');
        }
    }
})