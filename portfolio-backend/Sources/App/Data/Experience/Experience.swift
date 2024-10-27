import Fluent
import Vapor

typealias ExperienceType = Experience.ExperienceType

final class Experience: Model, Content, @unchecked Sendable {
    static let schema = "experiences"

    enum ExperienceType: String, Codable {
        case professional, education
    }

    @ID(key: .id)
    var id: UUID?

    @OptionalField(key: "imageURL")
    var imageURL: String?

    @Field(key: "name")
    var name: String

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
    var skills: [Skill]

    @Siblings(through: ProjectExperience.self, from: \.$experience, to: \.$project)
    var projects: [Project]

    init() {}

    init(id: UUID? = nil,
         imageURL: String?,
         name: String,
         type: ExperienceType,
         introduction: String?,
         period: Period,
         companyName: String?,
         missionDetails: String
         ) {
            self.id = id
            self.imageURL = imageURL
            self.name = name
            self.type = type
            self.introduction = introduction
            self.period = period
            self.companyName = companyName
            self.missionDetails = missionDetails
    }

    func toDTO() -> ExperienceDTO {
        .init(
            id: self.id,
            imageURL: self.imageURL,
            name: self.name,
            type: self.type,
            introduction: self.introduction,
            period: self.period,
            companyName: self.companyName,
            missionDetails: self.$missionDetails.value as? String,
            skills: self.skills.compactMap({$0.id}),
            projects: self.projects.compactMap({$0.id})
        )
    }
}
