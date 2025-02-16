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
    projects: Project[];
    experiences: Experience[];
}

type Type = 'technical' | 'soft';

export type SkillInput = Pick<Skill, "name", "type", "tags", "projects", "experiences">
