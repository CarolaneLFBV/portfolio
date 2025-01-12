export default function useAuthentication() {
    const tokenExpired = (jwt: string): boolean => {
        if (!jwt) return true;
        return JSON.parse(window.atob(jwt.split('.')[1])).exp < Math.trunc(Date.now() / 1000);
    }

    const isAdmin = (jwt: string | null): boolean => {
        if (!jwt) return false;
        try {
            const base64Url = jwt.split('.')[1];
            const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
            const payload = JSON.parse(window.atob(base64));
            return payload.role === 'admin';
        } catch (error) {
            console.error("Invalid token:", error);
            return false;
        }
    };
    
    const setToken = (jwt: string) => {
        sessionStorage.setItem('jwt', jwt);
    };

    const removeToken = () => {
        sessionStorage.removeItem('jwt');
    };

    return {tokenExpired, isAdmin, setToken, removeToken};
}
