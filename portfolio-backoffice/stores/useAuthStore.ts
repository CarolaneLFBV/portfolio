import {defineStore} from "pinia";
import type {User, UserCredentials, UserStore} from "~/types/user";
import useAuthentication from "~/composables/useAuthentication";

export const useAuthStore = defineStore("authStore", {
    state: (): UserStore => ({
        user: undefined,
    }),
    getters: {
        isAuth: (state: UserStore): boolean => !!state.user,
        isAdmin: (state: UserStore): boolean => state.user?.role === "admin",
    },
    actions: {
        async register(data: UserCredentials) {
          try {
              const response = await apiHelper.kyPublicPost<{ token: string, user: User }>('auth/register', data);
              if (response.success && response.data) {
                  const {token, user} = response.data;
                  const {setToken} = useAuthentication();
                  setToken(token);
                  this.user = user;
              }
          } catch (error) {
              console.log("Error registering user", error);
          }
        },
        async authenticateUser(data: UserCredentials) {
            try {
                const response = await apiHelper.kyPublicPost<{token: string, user: User}>('auth/login', data);
                const tokenStorage = sessionStorage.getItem("token") ?? "";
                const {token, user} = response.data;
                if (!tokenStorage && response.success && response.data) {
                    const {setToken} = useAuthentication();
                    setToken(token);
                }
                this.user = user;
            } catch (error) {
                console.error("Error authenticating user", error);
            }
        },
        logout() {
            const {tokenExpired, removeToken} = useAuthentication();
            const tokenStorage = sessionStorage.getItem("token") ?? "";

            if (tokenExpired(tokenStorage)) {
                removeToken();
            }
            this.user = undefined;
        },
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