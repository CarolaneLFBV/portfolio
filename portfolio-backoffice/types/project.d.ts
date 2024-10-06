import type {Skill} from "~/types/skill";
import type {Experience} from "~/types/experience";

export interface Project {
    id: string;
    title: string;
    presentation: string;
    purpose: string;
    milestone: string;
    actor: string;
    progress: string;
    skills: Skill[];
    experiences: Experience[];
}

export interface ProjectCreation {
    title: string;
    presentation: string;
    purpose: string;
    milestone: string;
    actor: string;
    progress: string;
    skills: Skill[];
    experiences: Experience[];
}