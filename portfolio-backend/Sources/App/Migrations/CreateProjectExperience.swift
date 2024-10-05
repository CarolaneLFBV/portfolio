import Fluent

struct CreateProjectExperience: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("project+experience")
            .id()
            .field("project_id", .uuid, .required, .references("projects", "id", onDelete: .cascade))
            .field("experience_id", .uuid, .required, .references("experiences", "id", onDelete: .cascade))
            .unique(on: "project_id", "experience_id")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("project+experience").delete()
    }
}
