import apiHelper from "~/utils/apiHelper";
import {ref} from "vue";
import type {Experience, ExperienceCreation} from "~/types/experience";

const newExperience = ref<ExperienceCreation>({
    name: '',
    tags: [],
    context: '',
    proofs: '',
    retrospective: '',
    progress: '',
    projects: [],
    experiences: []
});

export default function () {
    async function createExperience(experience: Experience) {
        try {
            const response = await apiHelper.kyPrivatePost<Experience>(`experiences/create`, experience);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la création du experience:', error);
            throw error;
        }
    }

    async function getExperienceById(experienceId: string) {
        try {
            const response = await apiHelper.kyPrivateGet<Experience>(`experiences/${experienceId}`);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la récupération du skill:', error);
            throw error;
        }
    }

    async function getExperiences() {
        try {
            const response = await apiHelper.kyPrivateGet<Experience[]>('experiences');
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la récupération des skills:', error);
            throw error;
        }
    }

    async function updateExperience(experience: Experience) {
        try {
            const response = await apiHelper.kyPrivatePatch<Experience>(`experiences/${experience.id}`, experience);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la mise à jour du skill:', error);
            throw error;
        }
    }

    // Response: HTTPCode
    async function deleteExperience(experienceId: string) {
        try {
            const response = await apiHelper.kyPrivateDelete(`experiences/${experienceId}`)
            return response;
        } catch (error) {
            console.error('Erreur lors de la suppression du projet:', error);
            throw error;
        }
    }

    return {
        newSkill,
        createSkill,
        getSkillById,
        getSkills,
        updateSkill,
        deleteSkill,
    }
}