import Fluent

struct CreateUser: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .id()
            .field("imageURL", .string)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("role", .string, .required)
            .field("fullName_firstName", .string)
            .field("fullName_lastName", .string)
            .field("bio", .string)
            .field("introduction", .string)
            .field("interests", .array(of: .string))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("users").delete()
    }
}
