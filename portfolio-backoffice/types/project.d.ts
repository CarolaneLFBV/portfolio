import type {Skill} from "~/types/skill";
import type {Experience} from "~/types/experience";

export interface Project {
    id: string;
    imageURLs?: String[];
    name: string;
    slug: string
    introduction?: string;
    presentation?: string;
    background: Background;
    technicalDetails: TechnicalDetails;
    skills: Skill[];
    experiences: Experience[];
}

export interface ProjectCreation {
    imageURLs?: String[];
    name: string;
    slug: string
    introduction?: string;
    presentation?: string;
    background: Background;
    technicalDetails: TechnicalDetails;
    skills: Skill[];
    experiences: Experience[];
}       

// Background 
type Background = {
    situationType?: SituationType;
    problemStatement?: string;
    projectRole?: string;
    achievedGoals?: string;
}

type SituationType = 'professional' | 'training' | 'personal'

// Technical Details
type TechnicalDetails = {
    technicalChoices?: string;
    challenges?: string;
    solutions?: string;
}
