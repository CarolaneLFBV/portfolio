export default function () {
    const tokenExpired = (token: string): boolean => {
        if (!token) return true;
        return JSON.parse(window.atob(token.split('.')[1])).exp < Math.trunc(Date.now() / 1000);
    }
    return {tokenExpired}
}
