import type {Project} from "~/types/project";
import {$fetch} from "ofetch";

export default function () {
    const config = useRuntimeConfig();
    const apiBaseUrl = config.public.apiBaseUrl;
    const tokenStorage = sessionStorage.getItem("jwt");

    async function getProjectImages(image?: File | string) {
        if (image instanceof File) {
            return URL.createObjectURL(image);
        }
        return image || '/public/okeep.png';
    }

    async function createProject(project: Project) {
        try {
            return await $fetch(`${apiBaseUrl}/projects/create`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`,
                },
                body: project,
            });
        } catch (error) {
            console.error("Error creating skill:", error);
            throw error;
        }
    }

    async function getProjects() {
        try {
            return await $fetch(`${apiBaseUrl}/projects`, {
                method: 'GET',
            });
        } catch (error) {
            console.error('Erreur lors de la récupération des projects:', error);
            throw error;
        }
    }

    async function getProjectBySlug(slug: string) {
        try {
            return await $fetch(`${apiBaseUrl}/projects/${slug}`, {
                method: 'GET',
            });
        } catch (error) {
            console.error('error get by slug', error);
            throw error;
        }
    }

    async function updateProject(slug: string, project: FormData) {
        try {
            return await $fetch(`${apiBaseUrl}/projects/${slug}`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`
                },
                body: project,
            })
        } catch (error) {
            console.error('Error updating skill', error);
        }
    }

    async function deleteProject(slug: string) {
        try {
            return await $fetch(`${apiBaseUrl}/projects/${slug}`, {
                method: 'DELETE',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`
                },
            });
        } catch (error) {
            console.error('error delete: ', error);
        }
    }

    return {
        createProject,
        getProjects,
        deleteProject,
        getProjectBySlug,
        updateProject,
        getProjectImages
    }
}