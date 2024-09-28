import Fluent

struct CreateSkill: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("skills")
            .id()
            .field("name", .string, .required)
            .field("tags", .array(of: .string))
            .field("context", .string)
            .field("proofs", .string)
            .field("retrospective", .string)
            .field("progress", .string)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("skills").delete()
    }
}
