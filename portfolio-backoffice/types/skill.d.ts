export interface Skill {
    id: string;
    name: string;
    tags: string[];
    context: string;
    proofs: string;
    retrospective: string;
    progress: string;
}

export interface SkillCreation {
    name: string;
    tags: string[];
    context: string;
    proofs: string;
    retrospective: string;
    progress: string;
}