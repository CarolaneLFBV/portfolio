import Fluent

struct CreateSkillExperience: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("skill+experience")
            .id()
            .field("skill_id", .uuid, .required, .references("skills", "id", onDelete: .cascade))
            .field("experience_id", .uuid, .required, .references("experiences", "id", onDelete: .cascade))
            .unique(on: "skill_id", "experience_id")
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("skill+experience").delete()
    }
}
