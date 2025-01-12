import type {SkillInput} from "~/types/skill";
import {$fetch} from "ofetch";

const newSkill = ref<SkillInput>({
    image: undefined,
    name: '',
    type: '',
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

    async function createSkill(skill: SkillInput) {
        try {
            return await $fetch(`${apiBaseUrl}/skills/create`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${tokenStorage}`
                },
                body: JSON.stringify(skill),
            });
        } catch (error) {
            console.log('Skill creation error:', error);
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

    return {
        newSkill,
        createSkill,
        getSkills
    }
}