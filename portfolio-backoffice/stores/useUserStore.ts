import { defineStore } from 'pinia';
import type {User, UserStore} from "~/types/user";
import useAuthentication from "~/composables/useAuthentication";
import {useRouter} from "#vue-router";
import apiHelper from "~/utils/apiHelper";

export const useUserStore = defineStore('userStore', {
    state: (): UserStore => ({
        user: undefined,
    }),
    actions: {
        async getAuthenticatedUser(){
            try {
                const tokenStorage = sessionStorage.getItem("token") ?? "";
                const {tokenExpired} = useAuthentication();

                if (tokenExpired(tokenStorage)) {
                    const router = useRouter();
                    await router.push("/auth/login");
                    return;
                }

                const response = await apiHelper.kyPrivateGet<User>('users/current');
                this.user = response;
            } catch (error) {
                console.error("Error while fetching user: ", error);
            }
        },
    }
});
