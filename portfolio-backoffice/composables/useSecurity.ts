export default function () {
    function setToken(token: string) {
        sessionStorage.setItem('token', token);
    }

    function removeToken() {
        sessionStorage.removeItem('token');
    }

    return {
        setToken,
        removeToken,
    }
}