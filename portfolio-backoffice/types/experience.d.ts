import type {Project} from "~/types/project";
import type {Skill} from "~/types/skill";

export interface Experience {
    id: string;
    type: Type;
    startDate: string;
    endDate: string;
    position?: string;
    companyName?: string;
    companyLogo?: string;
    degree?: string;
    misc?: string;
    status?: string;
    missionDetails?: string;
    projects: Project[];
    skills: Skill[];
}

export interface ExperienceCreation {
    type: Type;
    startDate: string;
    endDate: string;
    position?: string;
    companyName?: string;
    companyLogo?: string;
    degree?: string;
    misc?: string;
    status?: string;
    missionDetails?: string;
    projects: Project[];
    skills: Skill[];
}

interface Type {
    type: 'professional' | 'education';
}