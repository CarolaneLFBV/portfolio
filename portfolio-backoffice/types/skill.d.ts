import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";

export interface Skill {
    id: string;
    image?: File;
    name: string;
    slug: string;
    tags: string[];
    introduction: Introduction
    history?: string;
    projects: Project[];
    experiences: Experience[];
}

export interface SkillInput {
    image?: File;
    name: string;
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
