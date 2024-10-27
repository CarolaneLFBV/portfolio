import Fluent

struct CreateExperience: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("experiences")
            .id()
               .field("imageURL", .string)
               .field("name", .string, .required)
               .field("type", .string, .required)
               .field("period_startDate", .string, .required)
               .field("period_endDate", .string, .required)
               .field("introduction", .string)
               .field("companyName", .string)
               .field("missionDetails", .string)
               .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("experiences").delete()
    }
}
