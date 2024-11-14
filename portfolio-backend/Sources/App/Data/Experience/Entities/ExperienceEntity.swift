import Vapor
import Fluent

typealias ExperienceEntity = Experience.Entity
typealias ExperienceType = Experience.Entity.ExperienceType

extension Experience {
    final class Entity: Model, Content, @unchecked Sendable {
        static let schema = "experiences"

        enum ExperienceType: String, Codable {
            case professional, education
        }

        @ID(key: .id)
        var id: UUID?

        @OptionalField(key: "imageURLs")
        var imageURLs: [String]?

        @Field(key: "name")
        var name: String

        @Field(key: "slug")
        var slug: String

        @Field(key: "type")
        var type: ExperienceType

        @OptionalField(key: "introduction")
        var introduction: String?

        @Group(key: "period")
        var period: Period

        @OptionalField(key: "companyName")
        var companyName: String?

        @Field(key: "missionDetails")
        var missionDetails: String?

        @Siblings(through: SkillExperience.self, from: \.$experience, to: \.$skill)
        var skills: [Skill.Entity]

        @Siblings(through: ProjectExperience.self, from: \.$experience, to: \.$project)
        var projects: [Project.Entity]

        init() {}

        init(id: UUID? = nil,
             imageURLs: [String]?,
             name: String,
             slug: String,
             type: ExperienceType,
             introduction: String?,
             period: Period,
             companyName: String?,
             missionDetails: String
             ) {
                self.id = id
                self.imageURLs = imageURLs
                self.name = name
                self.slug = slug
                self.type = type
                self.introduction = introduction
                self.period = period
                self.companyName = companyName
                self.missionDetails = missionDetails
        }
    }
}

extension Experience.Entity {
    func toDTO(from db: Database) async throws -> Experience.Dto.Output {
        .init(
            id: id,
            imageURLs: imageURLs,
            name: name,
            slug: slug,
            type: type,
            introduction: introduction,
            period: period,
            companyName: companyName,
            missionDetails: missionDetails,
            skills: try await $skills.get(on: db).compactMap { $0.id },
            projects: try await $projects.get(on: db).compactMap { $0.id }
        )
    }
}
