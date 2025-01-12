import type {Project} from "~/types/project";
import type {Skill} from "~/types/skill";

export interface Experience {
    id: string;
    imageURLs?: string[];
    name: string;
    slug: string;
    type: Type;
    period: Period
    companyName?: string;
    missionDetails?: string;
    projects: Project[];
    skills: Skill[];
}

export interface ExperienceCreation {
    imageURLs?: string[];
    name: string;
    slug: string;
    type: Type;
    period: Period
    companyName?: string;
    missionDetails?: string;
    projects: Project[];
    skills: Skill[];
}

type Type = 'professional' | 'education';

type Period = {
    startDate: String;
    endDate: String;
}