import {$fetch} from "ofetch";
import type {ExperienceInput} from "~/types/experience";

export default function () {
    const newExperience = ref<ExperienceInput>({
        name: '',
        type: 'professional',
        period: {startDate: '', endDate: ''},
        companyName: '',
        missionDetails: '',
        projects: [],
        skills: [],
    });

    const config = useRuntimeConfig();
    const apiBaseUrl = config.public.apiBaseUrl;
    const tokenStorage = sessionStorage.getItem("jwt");

    async function createExperience(experience: FormData) {
        try {
            return await $fetch(`${apiBaseUrl}/experiences/create`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`,
                },
                body: experience,
            });
        } catch (error) {
            console.error("Error creating experience:", error);
            throw error;
        }
    }

    async function getExperiences() {
        try {
            return await $fetch(`${apiBaseUrl}/experiences`, {
                method: 'GET',
            });
        } catch (error) {
            console.error('Erreur lors de la récupération des experiences:', error);
            throw error;
        }
    }

    async function getExperienceBySlug(slug: string) {
        try {
            return await $fetch(`${apiBaseUrl}/experiences/${slug}`, {
                method: 'GET',
            });
        } catch (error) {
            console.error('error get by slug', error);
            throw error;
        }
    }

    async function updateExperience(slug: string, experience: FormData) {
        try {
            return await $fetch(`${apiBaseUrl}/experiences/${slug}`, {
                method: 'PATCH',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`
                },
                body: experience,
            })
        } catch (error) {
            console.error('Error updating experience', error);
        }
    }

    async function deleteExperience(slug: string) {
        try {
            return await $fetch(`${apiBaseUrl}/experiences/${slug}`, {
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
        newExperience,
        createExperience,
        getExperiences,
        deleteExperience,
        getExperienceBySlug,
        updateExperience,
    }
}