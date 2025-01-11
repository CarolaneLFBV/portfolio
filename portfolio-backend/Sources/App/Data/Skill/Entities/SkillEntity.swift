import Fluent
import Vapor

typealias SkillEntity = Skill.Entity
typealias SkillType = Skill.Entity.SkillType

extension Skill {
    final class Entity: Model, @unchecked Sendable {
        static let schema = "skills"

        enum SkillType: String, Codable {
            case technical, soft
        }

        @ID(key: .id)
        var id: UUID?

        @OptionalField(key: "imageURL")
        var imageURL: String?

        @Field(key: "name")
        var name: String

        @Field(key: "slug")
        var slug: String

        @Field(key: "type")
        var type: SkillType

        @Field(key: "tags")
        var tags: [String]

        @Group(key: "introduction")
        var introduction: Introduction

        @OptionalField(key: "history")
        var history: String?

        @Siblings(through: ProjectSkill.self, from: \.$skill, to: \.$project)
        var projects: [Project.Entity]

        @Siblings(through: SkillExperience.self, from: \.$skill, to: \.$experience)
        var experiences: [Experience.Entity]

        init() {}

        init(id: UUID? = nil,
             imageURL: String? = nil,
             name: String,
             slug: String,
             type: SkillType,
             tags: [String],
             introduction: Introduction,
             history: String?) {
            self.id = id
            self.imageURL = imageURL
            self.name = name
            self.slug = slug
            self.type = type
            self.tags = tags
            self.introduction = introduction
            self.history = history
        }
    }
}

extension Skill.Entity {
    func toDTO(from db: Database) async throws -> Skill.Dto.Output {
        .init(
            id: id,
            name: name,
            slug: slug,
            type: type,
            tags: tags,
            introduction: introduction,
            history: history,
            imageURL: imageURL,
            projects: try await $projects.get(on: db).compactMap { $0.id },
            experiences: try await $experiences.get(on: db).compactMap { $0.id }
        )
    }
}
