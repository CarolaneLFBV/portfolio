import Fluent

struct CreateProject: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("projects")
            .id()
            .field("imageURL", .string)
            .field("name", .string, .required)
            .field("introduction", .string)
            .field("presentation", .string)
            .field("context_situation", .string)
            .field("context_issue", .string)
            .field("context_role", .string)
            .field("context_goals", .string)
            .field("technicalDetails_choices", .string)
            .field("technicalDetails_challenges", .string)
            .field("technicalDetails_solutions", .string)
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("projects").delete()
    }
}
