import { defineStore } from 'pinia';
import type {User, UserStore} from "~/types/user";
import useAuthentication from "~/composables/useAuthentication";
import {useRouter} from "#vue-router";

export const useUserStore = defineStore('userStore', {
    state: (): UserStore => ({
        user: undefined
    }),
    actions: {
        async getAuthenticatedUser(){
            try {
                const tokenStorage = localStorage.getItem("token") ?? "";
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
        async getUserById(userID: srting) {
            try {
                const response = await apiHelper.kyPrivateGet(`users/${userID}`);
                return response;
            } catch (error) {
                console.error(error);
            }
        }
    }
});
