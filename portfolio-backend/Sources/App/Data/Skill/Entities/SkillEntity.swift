import Fluent
import Vapor

typealias SkillEntity = Skill.Entity

extension Skill {
    final class Entity: Model, @unchecked Sendable {
        static let schema = "skills"

        @ID(key: .id)
        var id: UUID?

        @OptionalField(key: "imageURL")
        var imageURL: String?

        @Field(key: "name")
        var name: String

        @Field(key: "slug")
        var slug: String

        @Field(key: "tags")
        var tags: [String]

        @Siblings(through: ProjectSkill.self, from: \.$skill, to: \.$project)
        var projects: [Project.Entity]

        @Siblings(through: SkillExperience.self, from: \.$skill, to: \.$experience)
        var experiences: [Experience.Entity]

        init() {}

        init(id: UUID? = nil,
             imageURL: String? = nil,
             name: String,
             slug: String,
             tags: [String]
        ) {
            self.id = id
            self.imageURL = imageURL
            self.name = name
            self.slug = slug
            self.tags = tags
        }
    }
}

extension Skill.Entity {
    func toDTO(from db: Database) async throws -> Skill.Dto.Output {
        .init(
            id: id,
            name: name,
            slug: slug,
            tags: tags,
            imageURL: imageURL,
            projects: try await $projects.get(on: db).compactMap { $0.id },
            experiences: try await $experiences.get(on: db).compactMap { $0.id }
        )
    }
}
