import apiHelper from "~/utils/apiHelper";
import type {Background, Project, ProjectCreation, TechnicalDetails} from "~/types/project";
import {ref} from "vue";
import type {Skill} from "~/types/skill";
import type {Experience} from "~/types/experience";

const newProject = ref<ProjectCreation>({
    imageURLs: [],
    name: '',
    slug: '',
    introduction: '',
    presentation: '',
    background: '',
    technicalDetails: '',
    skills:  [],
    experiences: []
});

export default function () {
    async function createProject(project: Project) {
        try {
            const response = await apiHelper.kyPrivatePost<Project>(`projects/create`, project);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la création du projet:', error);
            throw error;
        }
    }

    async function getProjectBySlug(slug: string) {
        try {
            const response = await apiHelper.kyPrivateGet<Project>(`projects/${slug}`);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la récupération du projet:', error);
            throw error;
        }
    }

    async function getProjects() {
        try {
            const response = await apiHelper.kyPrivateGet<Project[]>('projects');
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la récupération des projets:', error);
            throw error;        }
    }

    async function updateProject(project: Project) {
        try {
            const response = await apiHelper.kyPrivatePatch<Project>(`projects/${project.slug}`, project);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la mise à jour du projet:', error);
            throw error;
        }
    }

    // Response: HTTPCode
    async function deleteProject(slug: string) {
        try {
            const response = await apiHelper.kyPrivateDelete(`projects/${slug}`)
            return response;
        } catch (error) {
            console.error('Erreur lors de la suppression du projet:', error);
            throw error;
        }
    }

    return {
        newProject,
        createProject,
        getProjectBySlug,
        getProjects,
        updateProject,
        deleteProject
    }
}