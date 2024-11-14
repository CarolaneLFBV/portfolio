import Fluent

struct CreateProject: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("projects")
            .id()
            .field("imageURLs", .array(of: .string))
            .field("name", .string, .required)
            .field("slug", .string, .required)
            .field("introduction", .string)
            .field("presentation", .string)
            .field("background_situation", .string)
            .field("background_issue", .string)
            .field("background_role", .string)
            .field("background_goals", .string)
            .field("technicalDetails_choices", .string)
            .field("technicalDetails_challenges", .string)
            .field("technicalDetails_solutions", .string)
            .unique(on: "slug")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("projects").delete()
    }
}
