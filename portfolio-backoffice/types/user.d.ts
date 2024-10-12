export interface User {
    id: string;
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    role: Role;
}

export interface UserStore {
    user: User | undefined;
}

export interface UserCredentials {
    email: string;
    password: string;
    role: Role;
}

interface Role {
    role: 'admin' | 'member';
}