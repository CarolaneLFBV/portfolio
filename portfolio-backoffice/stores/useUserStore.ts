import {defineStore} from 'pinia'
import type {UserCredentials, UserStore} from '~/types/user'
import {$fetch} from 'ofetch'
import useAuthentication from "~/composables/useAuthentication";

export const useUserStore = defineStore('user', {
    state: (): UserStore => ({
        user: undefined,
    }),
    actions: {
        async login(credentials: UserCredentials) {
            const config = useRuntimeConfig()
            const apiBaseUrl = config.public.apiBaseUrl
            const tokenStorage = sessionStorage.getItem("jwt");

            try {
                const response = await $fetch(`${apiBaseUrl}/auth/login`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(credentials)
                });

                if (!tokenStorage && response && response.jwt) {
                    const jwt = response.jwt;
                    const {setToken} = useAuthentication();
                    setToken(jwt);
                }
            } catch (error) {
                console.log('Login error:', error)
                throw error
            }
        },
        async logout() {
            const {removeToken} = useAuthentication();
            removeToken();
            this.user = undefined;
            await navigateTo("/auth/logout");
        },
        async register(credentials: UserCredentials) {
            const config = useRuntimeConfig()
            const apiBaseUrl = config.public.apiBaseUrl

            try {
                await $fetch(`${apiBaseUrl}/auth/register`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    body: JSON.stringify(credentials)
                })
            } catch (error) {
                console.log('Register error:', error)
            }
        }
    },
    persist: true
})