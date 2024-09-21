import { defineStore } from 'pinia';
import apiHelper from '~/utils/apiHelper';
import { useAuthStore } from '~/stores/useAuthStore';
import type {UserStore} from "~/types/user";

export const useUserStore = defineStore('userStore', {
    state: (): UserStore => ({
        user: undefined
    }),
    actions: {
        //
    }
});
