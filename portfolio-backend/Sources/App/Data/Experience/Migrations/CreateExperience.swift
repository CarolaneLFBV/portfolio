import Fluent

struct CreateExperience: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("experiences")
            .id()
               .field("imageUrls", .array(of: .string))
               .field("logoUrl", .string)
               .field("name", .string, .required)
               .field("slug", .string, .required)
               .field("type", .string, .required)
               .field("period_startDate", .string, .required)
               .field("period_endDate", .string, .required)
               .field("companyName", .string)
               .field("missionDetails", .array(of: .string))
               .unique(on: "slug")
               .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("experiences").delete()
    }
}
