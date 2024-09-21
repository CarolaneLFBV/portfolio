export interface User {
    id: string;
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    role: 'admin' | 'member';
}

export interface UserStore {
    user: User | undefined;
}

export interface UserRegister {
    email: string;
    password: string;
    role: 'admin' | 'member';
}

export interface UserLogin {
    email: string;
    password: string;
    role: 'admin' | 'member';
}