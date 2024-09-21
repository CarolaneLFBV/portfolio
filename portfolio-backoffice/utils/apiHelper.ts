import ky from "ky";
import type { ApiResponse } from "~/types/api";
import { useAuthStore } from "~/stores/useAuthStore";

// API pour les requêtes publiques (sans token)
const publicApi = ky.create({
    prefixUrl: import.meta.env.VITE_API_URL,
    headers: {
        'Content-Type': 'application/json',
    }
});

// API pour les requêtes privées (avec token JWT)
const privateApi = publicApi.extend({
    hooks: {
        beforeRequest: [
            (request) => {
                const authStore = useAuthStore();
                const token = authStore.getToken();
                if (token) {
                    request.headers.set('Authorization', `Bearer ${token}`);
                }
            }
        ]
    }
});

// Requêtes publiques (pour login et register)
const kyPublicPost = async <T>(url: string, json: object): Promise<ApiResponse<T>> => {
    try {
        const response = await publicApi.post(url, { json }).json<T>();
        return { success: true, data: response };
    } catch (error) {
        console.log("Error in public POST request:", error);
        return { success: false, data: null };
    }
};

// Requêtes privées (pour l'administration ou les utilisateurs authentifiés)
const kyPrivatePost = async <T>(url: string, json: object): Promise<ApiResponse<T>> => {
    try {
        const response = await privateApi.post(url, { json }).json<T>();
        return { success: true, data: response };
    } catch (error) {
        console.log("Error in private POST request:", error);
        return { success: false, data: null };
    }
};

// Requêtes GET publiques ou privées
const kyGet = async <T>(url: string): Promise<ApiResponse<T>> => {
    try {
        const response = await publicApi.get(url).json<T>();
        return { success: true, data: response };
    } catch (error) {
        console.log("Error getting data", error);
        return { success: false, data: null };
    }
};

// Requêtes PATCH pour les mises à jour privées
const kyPatch = async <T>(url: string, json: object): Promise<ApiResponse<T>> => {
    try {
        const response = await privateApi.patch(url, { json }).json<T>();
        return { success: true, data: response };
    } catch (error) {
        console.log("Error patching data", error);
        return { success: false, data: null };
    }
};

// Requêtes DELETE pour les suppressions privées
const kyDelete = async <T>(url: string): Promise<ApiResponse<T>> => {
    try {
        const response = await privateApi.delete(url).json<T>();
        return { success: true, data: response };
    } catch (error) {
        console.log("Error deleting data", error);
        return { success: false, data: null };
    }
};

export default { kyGet, kyPrivatePost, kyPublicPost, kyPatch, kyDelete };
