export interface User {
    id: string;
    image?: File;
    imageURL?: string;
    firstName?: string;
    lastName?: string;
    nickName: string;
    slug: string;
    role: Role;
    email: string;
    password: string;
    bio?: string;
}

type Role = 'admin' | 'member';

export type UserStore = {
    user: User | undefined;
}

export type UserCredentials = Pick<User, 'email', 'password', 'role'>
export type UserInput = Pick<User, "firstName", "lastName", "nickName", "role", "email", "password", "bio">