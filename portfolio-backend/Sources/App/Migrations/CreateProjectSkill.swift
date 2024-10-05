import Fluent

struct CreateProjectSkill: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("project+skill")
            .id()
            .field("project_id", .uuid, .required, .references("projects", "id", onDelete: .cascade))
            .field("skill_id", .uuid, .required, .references("skills", "id", onDelete: .cascade))
            .unique(on: "project_id", "skill_id")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("project+skill").delete()
    }
}
