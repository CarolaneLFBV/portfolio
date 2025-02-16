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
    introduction?: string;
    presentation?: string;
    background: Background;
    technicalDetails: TechnicalDetails;
    skills: Skill[];
    experiences: Experience[];
}

type Background = {
    problemStatement?: string;
    projectRole?: string;
    achievedGoals?: string;
}

type Type = 'professional' | 'personal';

type TechnicalDetails = {
    technicalChoices?: string;
    challenges?: string;
    solutions?: string;
}

export type ProjectInput = Pick<Project, 'name', 'type', 'introduction', 'presentation', 'background', 'technicalDetails', 'skills', 'experiences'>
