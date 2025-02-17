import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";

export interface Skill {
    id: string;
    image?: File;
    imageURL?: string;
    name: string;
    slug: string;
    tags: string[];
    projects: Project[];
    experiences: Experience[];
}

export type SkillInput = Pick<Skill, "name", "tags", "projects", "experiences">
