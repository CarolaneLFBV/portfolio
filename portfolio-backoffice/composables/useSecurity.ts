export default function () {
    function setToken(token: string) {
        localStorage.setItem('token', token);
    }

    function removeToken() {
        localStorage.removeItem('token');
    }

    return {
        setToken,
        removeToken,
    }
}