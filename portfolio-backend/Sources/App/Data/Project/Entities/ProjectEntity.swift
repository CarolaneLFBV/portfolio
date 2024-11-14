import Fluent
import Vapor

typealias ProjectEntity = Project.Entity

extension Project {
    final class Entity: Model, @unchecked Sendable {
        static let schema = "projects"

        @ID(key: .id)
        var id: UUID?

        @OptionalField(key: "imageURLs")
        var imageURLs: [String]?

        @Field(key: "name")
        var name: String

        @Field(key: "slug")
        var slug: String

        @OptionalField(key: "introduction")
        var introduction: String?

        @OptionalField(key: "presentation")
        var presentation: String?

        @Group(key: "background")
        var background: Background

        @Group(key: "technicalDetails")
        var technicalDetails: TechnicalDetails

        @Siblings(through: ProjectSkill.self, from: \.$project, to: \.$skill)
        var skills: [Skill.Entity]

        @Siblings(through: ProjectExperience.self, from: \.$project, to: \.$experience)
        var experiences: [Experience.Entity]

        init() {}

        init(id: UUID? = nil,
             imageURLs: [String]?,
             name: String,
             slug: String,
             introduction: String?,
             presentation: String?,
             background: Background,
             technicalDetails: TechnicalDetails
        ) {
            self.id = id
            self.imageURLs = imageURLs
            self.name = name
            self.slug = slug
            self.introduction = introduction
            self.presentation = presentation
            self.background = background
            self.technicalDetails = technicalDetails
        }
    }
}

extension Project.Entity {
    func toDTO(from db: Database) async throws -> Project.Dto.Output {
        .init(
            id: id,
            imageURLs: imageURLs,
            name: name,
            slug: slug,
            introduction: introduction,
            presentation: presentation,
            background: background,
            technicalDetails: technicalDetails,
            skills: try await $skills.get(on: db).compactMap { $0.id },
            experiences: try await $experiences.get(on: db).compactMap { $0.id }
        )
    }
}
