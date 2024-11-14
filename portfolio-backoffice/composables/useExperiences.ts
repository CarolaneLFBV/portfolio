import apiHelper from "~/utils/apiHelper";
import {ref} from "vue";
import type {Experience, ExperienceCreation} from "~/types/experience";

const newExperience = ref<ExperienceCreation>({
    imageURLs: [],
    name: '',
    slug: '',
    type: '',
    period: {
        startDate: '',
        endDate: ''
    },
    companyName: '',
    missionDetails: '',
    projects: [],
    skills: []
});

export default function () {
    async function create(experience: Experience) {
        try {
            const response = await apiHelper.kyPrivatePost<Experience>(`experiences/create`, experience);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la création du experience:', error);
            throw error;
        }
    }

    async function getExperienceBySlug(slug: string) {
        try {
            const response = await apiHelper.kyPrivateGet<Experience>(`experiences/${slug}`);
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

    async function update(experience: Experience) {
        try {
            const response = await apiHelper.kyPrivatePatch<Experience>(`experiences/${experience.slug}`, experience);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la mise à jour du skill:', error);
            throw error;
        }
    }

    async function deleteExperience(slug: string) {
        try {
            const response = await apiHelper.kyPrivateDelete(`experiences/${slug}`)
            return response;
        } catch (error) {
            console.error('Erreur lors de la suppression du projet:', error);
            throw error;
        }
    }

    return {
        newExperience,
        create,
        getExperienceBySlug,
        getExperiences,
        update,
        deleteExperience,
    }
}