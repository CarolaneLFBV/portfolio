import Fluent

struct CreateSkill: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("skills")
            .id()
            .field("imageURL", .string)
            .field("name", .string, .required)
            .field("tags", .array(of: .string), .required)
            .field("introduction_definition", .string)
            .field("introduction_context", .string)
            .field("history", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("skills").delete()
    }
}
