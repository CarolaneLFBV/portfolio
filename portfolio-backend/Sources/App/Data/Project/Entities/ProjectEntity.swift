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

        @OptionalField(key: "logoUrl")
        var logoUrl: String?

        @Field(key: "name")
        var name: String

        @Field(key: "slug")
        var slug: String

        @Field(key: "type")
        var type: ProjectType

        @Field(key: "link")
        var link: String?

        @OptionalField(key: "presentation")
        var presentation: String?

        @Siblings(through: ProjectSkill.self, from: \.$project, to: \.$skill)
        var skills: [Skill.Entity]

        @Siblings(through: ProjectExperience.self, from: \.$project, to: \.$experience)
        var experiences: [Experience.Entity]

        init() {}

        init(id: UUID? = nil,
             logoUrl: String?,
             name: String,
             slug: String,
             type: ProjectType,
             presentation: String?,
             link: String?
        ) {
            self.id = id
            self.logoUrl = logoUrl
            self.name = name
            self.slug = slug
            self.type = type
            self.presentation = presentation
            self.link = link
        }
    }
}

extension Project.Entity {
    func toDTO(from db: Database) async throws -> Project.Dto.Output {
        .init(
            id: id,
            logoUrl: logoUrl,
            name: name,
            slug: slug,
            link: link,
            type: type,
            presentation: presentation,
            skills: try await $skills.get(on: db).compactMap { $0.id },
            experiences: try await $experiences.get(on: db).compactMap { $0.id }
        )
    }
}
