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

export type UserCredentials = Pick<User, 'email', 'password', 'role'>

type Role = 'admin' | 'member';