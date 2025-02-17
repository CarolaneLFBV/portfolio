import type {Skill} from "~/types/skill";
import type {Experience} from "~/types/experience";

export interface Project {
    id: string;
    imageURLs?: string[];
    logoUrl?: string;
    link?: string;
    name: string;
    presentation?: string;
    skills: Skill[];
    experiences: Experience[];
}
