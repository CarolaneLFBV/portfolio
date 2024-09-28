import Fluent

struct CreateExperience: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("experiences")
            .id()
            .field("type", .string, .required)
            .field("startDate", .date, .required)
            .field("endDate", .date, .required)
            .field("position", .string)
            .field("status", .string)
            .field("missionDetails", .string)
            .field("companyName", .string)
            .field("companyLogo", .string)
            .field("degree", .string)
            .field("misc", .string)
            .field("skillID", .uuid, .references("skills", "id"))
            .field("projectID", .uuid, .references("projects", "id"))
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("experiences").delete()
    }
}
