import type { UserCredentials } from '~/types/user'

const userCred = ref<UserCredentials>({
    nickName: '',
    email: '',
    password: '',
    role: ''
})

export default function () {
    return {
        userCred
    }
}