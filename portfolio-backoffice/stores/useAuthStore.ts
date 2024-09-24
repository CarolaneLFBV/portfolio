import {defineStore} from "pinia";
import useSecurity from "~/composables/useSecurity";
import type {User, UserLogin, UserRegister, UserStore} from "~/types/user";
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
        async register(data: UserRegister) {
          try {
              const response = await apiHelper.kyPublicPost<{ token: string, user: User }>('auth/register', data);
              if (response.success && response.data) {
                  const {token, user} = response.data;
                  const {setToken} = useSecurity()
                  setToken(token);
                  this.user = user;
              }
          } catch (error) {
              console.log("Error registering user", error);
          }
        },
        async authenticateUser(data: UserLogin) {
            try {
                const response = await apiHelper.kyPublicPost<{token: string, user: User}>('auth/login', data);
                const tokenStorage = localStorage.getItem("token") ?? "";
                const {token, user} = response.data;
                if (!tokenStorage && response.success && response.data) {
                    const {setToken} = useSecurity()
                    setToken(token);
                }
                this.user = user;
            } catch (error) {
                console.error("Error authenticating user", error);
            }
        },
        logout() {
            const {removeToken} = useSecurity();
            const {tokenExpired} = useAuthentication();
            const tokenStorage = localStorage.getItem("token") ?? "";

            if (tokenExpired(tokenStorage)) {
                removeToken();
            }
            this.user = undefined;
        },
    }
})