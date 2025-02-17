import type {Project} from "~/types/project";
import type {Experience} from "~/types/experience";

export interface Skill {
    id: string;
    imageURL?: string;
    name: string;
    tags: string[];
    projects: Project[];
    experiences: Experience[];
}
