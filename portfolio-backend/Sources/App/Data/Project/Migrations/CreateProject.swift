import Fluent

struct CreateProject: AsyncMigration {
    func prepare(on database: any Database) async throws {
        try await database.schema("projects")
            .id()
            .field("imageUrls", .array(of: .string))
            .field("logoUrl", .string)
            .field("name", .string, .required)
            .field("slug", .string, .required)
            .field("type", .string, .required)
            .field("presentation", .string)
            .unique(on: "slug")
            .create()
    }

    func revert(on database: any Database) async throws {
        try await database.schema("projects").delete()
    }
}
