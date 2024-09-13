import type {Project} from "~/types/project";
import type {Skill} from "~/types/skill";

export interface Experience {
    id: string;
    type: 'professional' | 'education';
    startDate: Date;
    endDate: Date;
    position?: string;
    companyName?: string;
    companyLogo?: string;
    skill: Skill;
    project: Project;
    degree?: string;
    misc?: string;
    status?: string;
    missionDetails?: string;
}