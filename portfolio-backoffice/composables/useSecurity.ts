import {useUserStore} from "~/stores/useUserStore";
import type {UserRegisterData} from "~/types/user";

const user = ref<UserRegisterData>({
    email: '',
    password: '',
    role: '',
})

export default function () {
    function setToken(token: string) {
        localStorage.setItem('token', token);
    }

    function removeToken() {
        localStorage.removeItem('token');
    }

    function getToken() {
        localStorage.getItem('token');
    }

    return {
        user,
        setToken,
        removeToken,
        getToken
    }
}