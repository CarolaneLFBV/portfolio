import Fluent
import Vapor

typealias ProjectEntity = Project.Entity
typealias ProjectType = Project.Entity.ProjectType

extension Project {
    final class Entity: Model, @unchecked Sendable {
        static let schema = "projects"

        enum ProjectType: String, Codable {
            case professional, personal
        }

        @ID(key: .id)
        var id: UUID?

        @OptionalField(key: "imageUrls")
        var imageUrls: [String]?

        @OptionalField(key: "logoUrl")
        var logoUrl: String?

        @Field(key: "name")
        var name: String

        @Field(key: "slug")
        var slug: String

        @Field(key: "type")
        var type: ProjectType

        @OptionalField(key: "presentation")
        var presentation: String?

        @Siblings(through: ProjectSkill.self, from: \.$project, to: \.$skill)
        var skills: [Skill.Entity]

        @Siblings(through: ProjectExperience.self, from: \.$project, to: \.$experience)
        var experiences: [Experience.Entity]

        init() {}

        init(id: UUID? = nil,
             imageUrls: [String]?,
             logoUrl: String?,
             name: String,
             slug: String,
             type: ProjectType,
             presentation: String?
        ) {
            self.id = id
            self.imageUrls = imageUrls
            self.logoUrl = logoUrl
            self.name = name
            self.slug = slug
            self.type = type
            self.presentation = presentation
        }
    }
}

extension Project.Entity {
    func toDTO(from db: Database) async throws -> Project.Dto.Output {
        .init(
            id: id,
            imageUrls: imageUrls,
            logoUrl: logoUrl,
            name: name,
            slug: slug,
            type: type,
            presentation: presentation,
            skills: try await $skills.get(on: db).compactMap { $0.id },
            experiences: try await $experiences.get(on: db).compactMap { $0.id }
        )
    }
}
