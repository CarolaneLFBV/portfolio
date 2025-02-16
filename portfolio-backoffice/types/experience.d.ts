import type {Project} from "~/types/project";
import type {Skill} from "~/types/skill";

export interface Experience {
    id: string;
    images?: File[];
    imageURLs?: string[];
    logo?: File;
    logoUrl?: string;
    name: string;
    slug: string;
    type: Type;
    period: Period
    companyName?: string;
    missionDetails?: string;
    projects: Project[];
    skills: Skill[];
}

type Type = 'professional' | 'personal';

type Period = {
    startDate: String;
    endDate: String;
}

export type ExperienceInput = Pick<Experience, "name", "type", "period", "companyName", "missionDetails", "projects", "skills">
