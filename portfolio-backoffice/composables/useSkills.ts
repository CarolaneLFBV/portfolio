import apiHelper from "~/utils/apiHelper";
//import {ref} from "vue";
import type {Skill, SkillCreation} from "~/types/skill";

export default function () {
    async function createSkill(skill: SkillCreation) {
        try {
            const response = await apiHelper.kyPrivatePost<SkillCreation>(`skills/create`, skill);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la création du skill:', error);
            throw error;
        }
    }

    async function getSkillByID(skillID: string) {
        try {
            const response = await apiHelper.kyPrivateGet<Skill>(`skills/${skillID}`);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la récupération du skill:', error);
            throw error;
        }
    }

    async function getSkills() {
        try {
            const response = await apiHelper.kyPrivateGet<Skill[]>('skills');
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la récupération des skills:', error);
            throw error;        }
    }

    async function updateSkill(skill: Skill) {
        try {
            const response = await apiHelper.kyPrivatePatch<Skill>(`skills/${skill.id}`, skill);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la mise à jour du skill:', error);
            throw error;
        }
    }

    // Response: HTTPCode
    async function deleteSkill(skillID: string) {
        try {
            const response = await apiHelper.kyPrivateDelete(`skills/${skillID}`)
            return response;
        } catch (error) {
            console.error('Erreur lors de la suppression du projet:', error);
            throw error;
        }
    }

    return {
        createSkill,
        getSkillByID,
        getSkills,
        updateSkill,
        deleteSkill
    }
}