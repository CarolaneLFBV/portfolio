import Fluent

struct CreateProject: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("projects")
            .id()
            .field("title", .string)
            .field("presentation", .string)
            .field("purpose", .string)
            .field("milestone", .string)
            .field("actor", .string)
            .field("progress", .string)
            .field("skillID", .uuid, .required, .references("skills", "id"))
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("projects").delete()
    }
}
