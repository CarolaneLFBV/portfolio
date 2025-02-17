import type {Skill} from "~/types/skill";
import type {Experience} from "~/types/experience";

export interface Project {
    id: string;
    logo?: File;
    logoUrl?: string;
    name: string;
    link?: string;
    slug: string
    type: Type,
    presentation?: string;
    skills: Skill[];
    experiences: Experience[];
}

type Type = 'professional' | 'personal';

export type ProjectInput = Pick<Project, 'name', 'type', 'link', 'presentation', 'skills', 'experiences'>
