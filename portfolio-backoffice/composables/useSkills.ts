import apiHelper from "~/utils/apiHelper";
import {ref} from "vue";
import type {Skill, SkillInput} from "~/types/skill";

const newSkill = ref<SkillInput>({
    image: undefined,
    name: '',
    tags: [],
    introduction: { definition: '', context: '' },
    history: '',
    projects: [],
    experiences: [],
});

export default function () {
    async function createSkill(skill: SkillInput) {
        // Convert SkillInput to FormData for file upload
        const formData = new FormData();
        formData.append('name', skill.name);
        formData.append('tags', skill.tags.join(',')); // Convert array to comma-separated string
        formData.append('introduction[definition]', skill.introduction.definition || '');
        formData.append('introduction[context]', skill.introduction.context || '');
        if (skill.history) formData.append('history', skill.history);

        // Append projects and experiences as IDs
        skill.projects.forEach(project => formData.append('projects[]', project.id.toString()));
        skill.experiences.forEach(experience => formData.append('experiences[]', experience.id.toString()));

        // Append the image file if it exists
        if (skill.image) {
            formData.append('image', skill.image);
        }

        // Send FormData using apiHelper
        try {
            const response = await apiHelper.kyPrivatePost<Skill>(`skills/create`, {
                body: formData,
                headers: {
                    Accept: 'application/json',
                },
            });
            return response.data;
        } catch (error) {
            console.error('Error creating skill:', error);
            throw error;
        }
    }

    async function getSkillBySlug(slug: string) {
        try {
            const response = await apiHelper.kyPrivateGet<Skill>(`skills/${slug}`);
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
            const response = await apiHelper.kyPrivatePatch<Skill>(`skills/${skill.slug}`, skill);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la mise à jour du skill:', error);
            throw error;
        }
    }

    async function deleteSkill(slug: string) {
        try {
            const response = await apiHelper.kyPrivateDelete(`skills/${slug}`)
            return response;
        } catch (error) {
            console.error('Erreur lors de la suppression du projet:', error);
            throw error;
        }
    }

    return {
        newSkill,
        createSkill,
        getSkillBySlug,
        getSkills,
        updateSkill,
        deleteSkill,
    }
}