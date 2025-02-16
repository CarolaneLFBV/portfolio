import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .id()
            .field("imageURL", .string)
            .field("firstName", .string)
            .field("lastName", .string)
            .field("nickName", .string, .required)
            .field("slug", .string, .required)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("role", .string, .required)
            .field("bio", .string)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("users").delete()
    }
}
