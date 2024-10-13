import {defineStore} from "pinia";
import type {User, UserCredentials, UserStore} from "~/types/user";
import useAuthentication from "~/composables/useAuthentication";
import {useRouter} from "#vue-router";
import apiHelper from "~/utils/apiHelper";

export const useAuthStore = defineStore("authStore", {
    state: (): UserStore => ({
        user: undefined,
    }),
    actions: {
        async register(data: UserCredentials) {
          try {
              const response = await apiHelper.kyPublicPost<{ jwt: string }>('auth/register', data);
              if (response.success && response.data) {
                  const {jwt} = response.data;
                  const {setToken} = useAuthentication();
                  setToken(jwt);
              }
          } catch (error) {
              console.log("Error registering user", error);
          }
        },
        async logIn(data: UserCredentials) {
            try {
                const response = await apiHelper.kyPublicPost<{ jwt: string }>('auth/login', data);
                const tokenStorage = sessionStorage.getItem("jwt") ?? "";
                if (!tokenStorage && response.success && response.data) {
                    const {jwt} = response.data;
                    const {setToken} = useAuthentication();
                    setToken(jwt);
                }
            } catch (error) {
                console.error("Error authenticating user", error);
            }
        },
        logOut() {
            const {tokenExpired, removeToken} = useAuthentication();
            const tokenStorage = sessionStorage.getItem("jwt") ?? "";

            if (tokenExpired(tokenStorage)) {
                removeToken();
            }
            this.user = undefined;
        },
        async getAuthenticatedUser() {
            try {
                const jwt = sessionStorage.getItem('jwt') ?? '';
                const { tokenExpired } = useAuthentication();
                const router = useRouter();

                if (tokenExpired(jwt)) {
                    await router.push('/disconnect');
                    return;
                }
                const response = await apiHelper.kyPrivateGet<User>('users/current');
                this.user = response;
            } catch (error) {
                console.error('Error while fetching user: ', error);
            }
        }
    },
    persist: {
        enabled: true,
        strategies: [
            {
                key: 'auth',
                storage: import.meta.client ? sessionStorage : null,
            },
        ],
    },
})