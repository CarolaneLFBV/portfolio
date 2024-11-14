export interface User {
    id: string;
    firstName?: string;
    lastName?: string;
    nickName: string;
    slug: string; 
    role: Role;
    email: string;
    password: string;
    bio?: string; 
    introduction?: string;
    interests?: string[];
}

export type UserStore = {
    user: User | undefined;
}

export type UserCredentials = {
    email: string;
    password: string;
    role: Role;
}

type Role = 'admin' | 'member';