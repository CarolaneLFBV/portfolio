import type {Skill} from "~/types/skill";

export interface Project {
    id: string;
    title: string;
    presentation: string;
    purpose: string;
    milestone: string;
    actor: string;
    progress: string;
    skill: Skill;
}