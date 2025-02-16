import {$fetch} from "ofetch";
import type {ProjectInput} from "~/types/project";

export default function () {
    const config = useRuntimeConfig();
    const apiBaseUrl = config.public.apiBaseUrl;
    const tokenStorage = sessionStorage.getItem("jwt");

    const newProject = ref<ProjectInput>({
        name: '',
        introduction: '',
        presentation: '',
        type: 'professional',
        skills: [],
        experiences: [],
    });

    async function createProject(project: FormData) {
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
                method: 'PATCH',
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
        newProject,
        createProject,
        getProjects,
        deleteProject,
        getProjectBySlug,
        updateProject,
    }
}