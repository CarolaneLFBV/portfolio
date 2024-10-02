import useAuthentication from "~/composables/useAuthentication";
import useSecurity from "~/composables/useSecurity";

export default defineNuxtRouteMiddleware((to, from) => {
    if (import.meta.client) {
        const token = sessionStorage.getItem("token");
        const {tokenExpired} = useAuthentication();
        const {removeToken} = useSecurity();
        if (!token || tokenExpired(token)) {
            removeToken();
            return navigateTo('/auth/login');
        }
    }
})