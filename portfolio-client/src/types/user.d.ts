export interface User {
    id: string;
    imageURL?: string;
    firstName?: string;
    lastName?: string;
    nickName: string;
    bio?: string;
}

export type UserInput = Pick<User, "firstName", "lastName", "nickName", "bio">
