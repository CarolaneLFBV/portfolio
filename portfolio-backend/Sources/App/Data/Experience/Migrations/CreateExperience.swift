import Fluent

struct CreateExperience: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("experiences")
            .id()
               .field("imageURLs", .array(of: .string))
               .field("name", .string, .required)
               .field("slug", .string, .required)
               .field("type", .string, .required)
               .field("period_startDate", .string, .required)
               .field("period_endDate", .string, .required)
               .field("introduction", .string)
               .field("companyName", .string)
               .field("missionDetails", .string)
               .unique(on: "slug")
               .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("experiences").delete()
    }
}
