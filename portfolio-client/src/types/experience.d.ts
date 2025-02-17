import type {Project} from "~/types/project";
import type {Skill} from "~/types/skill";

export interface Experience {
    id: string;
    logo?: File;
    logoUrl?: string;
    name: string;
    link?: string;
    type: Type;
    period: Period
    companyName?: string;
    missionDetails?: string[];
    projects: Project[];
    skills: Skill[];
}

type Type = 'professional' | 'educational';

type Period = {
    startDate: string;
    endDate: string;
}
