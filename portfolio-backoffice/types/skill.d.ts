import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";

export interface Skill {
    id: string;
    image?: File;
    imageURL?: string;
    name: string;
    slug: string;
    type: Type;
    tags: string[];
    introduction: Introduction
    history?: string;
    projects: Project[];
    experiences: Experience[];
}

export type SkillInput = Pick<Skill, "image", "name", "type", "tags", "introduction", "history", "projects", "experiences">

type Introduction = {
    definition?: string;
    context?: string;
}

type Type = 'technical' | 'soft';
