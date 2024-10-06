import apiHelper from "~/utils/apiHelper";
import type {Project, ProjectCreation} from "~/types/project";
import {ref} from "vue";

const newProject = ref<ProjectCreation>({
    title: '',
    presentation: '',
    purpose: '',
    milestone: '',
    actor: '',
    progress: '',
    skills: [],
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

    async function getProjectById(projectID: string) {
        try {
            const response = await apiHelper.kyPrivateGet<Project>(`projects/${projectID}`);
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
            const response = await apiHelper.kyPrivatePatch<Project>(`projects/${project.id}`, project);
            return response.data;
        } catch (error) {
            console.error('Erreur lors de la mise à jour du projet:', error);
            throw error;
        }
    }

    // Response: HTTPCode
    async function deleteProject(projectID: string) {
        try {
            const response = await apiHelper.kyPrivateDelete(`projects/${projectID}`)
            return response;
        } catch (error) {
            console.error('Erreur lors de la suppression du projet:', error);
            throw error;
        }
    }

    return {
        newProject,
        createProject,
        getProjectById,
        getProjects,
        updateProject,
        deleteProject
    }
}