import Fluent
import Vapor

struct CreateUser: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("users")
            .id()
            .field("firstName", .string)
            .field("lastName", .string)
            .field("email", .string, .required)
            .field("password", .string, .required)
            .field("role", .string, .required)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("users").delete()
    }
}
