import type {UserRegister} from "~/types/user";
import { useRouter } from 'vue-router';

const user = ref<UserRegister>({
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

    return {
        user,
        setToken,
        removeToken,
    }
}