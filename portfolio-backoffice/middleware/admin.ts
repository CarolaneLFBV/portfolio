import {useAuthStore} from "~/stores/useAuthStore";

export default defineNuxtRouteMiddleware((to, from) => {
    const authStore = useAuthStore();
    if (!authStore.isAdmin) {
        console.log("NOT ADMIN")
    }
})