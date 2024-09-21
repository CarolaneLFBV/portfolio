import { defineStore } from 'pinia';
import type {UserStore} from "~/types/user";

export const useUserStore = defineStore('userStore', {
    state: (): UserStore => ({
        user: undefined
    }),
    actions: {

    }
});
