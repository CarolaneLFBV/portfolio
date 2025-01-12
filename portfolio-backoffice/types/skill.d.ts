import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";

export interface Skill {
    id: string;
    image?: File | string;
    name: string;
    slug: string;
    type: Type;
    tags: string[];
    introduction: Introduction
    history?: string;
    projects: Project[];
    experiences: Experience[];
}

export interface SkillInput {
    image?: null;
    name: string;
    type: string;
    tags: string[];
    introduction: Introduction
    history?: string;
    projects: Project[];
    experiences: Experience[];
}

type Introduction = {
    definition?: string;
    context?: string;
}

type Type = 'technical' | 'soft';
