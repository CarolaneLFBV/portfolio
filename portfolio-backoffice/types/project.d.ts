import type {Skill} from "~/types/skill";
import type {Experience} from "~/types/experience";

export interface Project {
    id: string;
    images?: File[];
    imageURLs?: string[];
    logo?: File;
    logoUrl?: string;
    name: string;
    slug: string
    type: Type,
    presentation?: string;
    skills: Skill[];
    experiences: Experience[];
}

type Type = 'professional' | 'personal';

export type ProjectInput = Pick<Project, 'name', 'type', 'presentation', 'skills', 'experiences'>
