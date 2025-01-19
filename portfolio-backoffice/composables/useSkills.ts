import type {SkillInput} from "~/types/skill";
import {$fetch} from "ofetch";

const newSkill = ref<SkillInput>({
    image: undefined,
    slug: '',
    name: '',
    type: 'technical',
    tags: [],
    introduction: {definition: '', context: ''},
    history: '',
    projects: [],
    experiences: [],
});

export default function () {
    const config = useRuntimeConfig();
    const apiBaseUrl = config.public.apiBaseUrl;
    const tokenStorage = sessionStorage.getItem("jwt");

    async function getSkillImage(image?: File | string) {
        if (image instanceof File) {
            return URL.createObjectURL(image);
        }
        return image || '/public/okeep.png';
    }

    async function createSkill(formData: FormData) {
        try {
            return await $fetch(`${apiBaseUrl}/skills/create`, {
                method: 'POST',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`
                },
                body: formData,
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

    async function updateSkill(slug: string, formData: FormData) {
        try {
            return await $fetch(`${apiBaseUrl}/skills/${slug}`, {
                method: 'PATCH',
                headers: {
                    'Authorization': `Bearer ${tokenStorage}`
                },
                body: formData,
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
        getSkillImage
    }
}