import ky from "ky";
import type { ApiResponse } from "~/types/api";

const publicApi = ky.create({
    prefixUrl: import.meta.env.VITE_API_URL,
    headers: {
        'Content-Type': 'application/json',
    }
});

const privateApi = publicApi.extend({
    hooks: {
        beforeRequest: [
            (request) => {
                const token = sessionStorage.getItem("jwt") ?? "";
                if (token) {
                    request.headers.set('Authorization', `Bearer ${token}`);
                } else {
                    console.error("No token found in sessionStorage");
                }
            }
        ]
    }
});

const request = async <T>(api: typeof ky, method: string, url: string, json?: object): Promise<ApiResponse<T>> => {
    try {
        const response = await api(url, {method, json}).json<T>();
        return { success: true, data: response };
    } catch (error) {
        console.log(`Error during ${method} request to ${url}`, error);
        return { success: false, data: null };
    }
}

const kyPublicPost = <T>(url: string, json: object): Promise<ApiResponse<T>> => {
    return request(publicApi, "POST", url, json);
};

const kyPrivatePost = <T>(url: string, json: object): Promise<ApiResponse<T>> => {
    return request(privateApi, "POST", url, json);
};

const kyPrivateGet = <T>(url: string): Promise<ApiResponse<T>> => {
    return request(privateApi, "GET", url);
};

const kyPrivatePatch = <T>(url: string, json: object): Promise<ApiResponse<T>> => {
    return request(privateApi, "PATCH", url, json);
};

const kyPrivateDelete = <T>(url: string): Promise<ApiResponse<T>> => {
    return request(privateApi, "DELETE", url);
};


export default { kyPrivateGet, kyPrivatePost, kyPublicPost, kyPrivatePatch, kyPrivateDelete };
