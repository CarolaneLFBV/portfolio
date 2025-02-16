import type {SkillInput} from "~/types/skill";
import {$fetch} from "ofetch";

export default function () {
    const newSkill = ref<SkillInput>({
        name: '',
        type: 'technical',
        tags: [],
        projects: [],
        experiences: [],
    });

    const config = useRuntimeConfig();
    const apiBaseUrl = config.public.apiBaseUrl;
    const tokenStorage = sessionStorage.getItem("jwt");

    async function createSkill(skill: FormData) {
        try {
            return await $fetch(`${apiBaseUrl}/skills/create`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`,
                },
                body: skill,
            });
        } catch (error) {
            console.error("Error creating skill:", error);
            throw error;
        }
    }

    async function getSkills() {
        try {
            return await $fetch(`${apiBaseUrl}/skills`, {
                method: 'GET',
            });
        } catch (error) {
            console.error('Erreur lors de la récupération des skills:', error);
            throw error;
        }
    }

    async function getSkillBySlug(slug: string) {
        try {
            return await $fetch(`${apiBaseUrl}/skills/${slug}`, {
                method: 'GET',
            });
        } catch (error) {
            console.error('error get by slug', error);
            throw error;
        }
    }

    async function updateSkill(slug: string, skill: FormData) {
        try {
            return await $fetch(`${apiBaseUrl}/skills/${slug}`, {
                method: 'PATCH',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`
                },
                body: skill,
            })
        } catch (error) {
            console.error('Error updating skill', error);
        }
    }

    async function deleteSkill(slug: string) {
        try {
            return await $fetch(`${apiBaseUrl}/skills/${slug}`, {
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
        newSkill,
        createSkill,
        getSkills,
        deleteSkill,
        getSkillBySlug,
        updateSkill,
    }
}