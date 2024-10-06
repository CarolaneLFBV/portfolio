import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";

export interface Skill {
    id: string;
    name: string;
    tags: string[];
    context: string;
    proofs: string;
    retrospective: string;
    progress: string;
    projects: Project[];
    experiences: Experience[];
}

export interface SkillCreation {
    name: string;
    tags: string[];
    context: string;
    proofs: string;
    retrospective: string;
    progress: string;
    projects: Project[];
    experiences: Experience[];
}