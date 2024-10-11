import Fluent
import Vapor

final class Experience: Model, @unchecked Sendable {
    static let schema = "experiences"

    enum ExperienceType: String, Codable {
        case professionnal, education
    }

    @ID(key: .id)
    var id: UUID?

    @Field(key: "type")
    var type: ExperienceType

    @Field(key: "startDate")
    var startDate: String

    @Field(key: "endDate")
    var endDate: String

    @Field(key: "position")
    var position: String?

    @Field(key: "companyName")
    var companyName: String?

    @Field(key: "companyLogo")
    var companyLogo: String?

    @Field(key: "status")
    var status: String?

    @Field(key: "missionDetails")
    var missionDetails: String?

    @Field(key: "degree")
    var degree: String?

    @Field(key: "misc")
    var misc: String?

    @Siblings(through: SkillExperience.self, from: \.$experience, to: \.$skill)
    var skills: [Skill]

    @Siblings(through: ProjectExperience.self, from: \.$experience, to: \.$project)
    var projects: [Project]

    init() {}

    init(id: UUID? = nil,
         type: ExperienceType,
         startDate: String,
         endDate: String,
         position: String,
         status: String,
         missionDetails: String,
         degree: String,
         misc: String,
         companyName: String,
         companyLogo: String) {
            self.id = id
            self.type = type
            self.startDate = startDate
            self.endDate = endDate
            self.position = position
            self.status = status
            self.missionDetails = missionDetails
            self.degree = degree
            self.misc = misc
            self.companyName = companyName
            self.companyLogo = companyLogo
       }

    func toDTO() -> ExperienceDTO {
        .init(
            id: self.id,
            type: self.type,
            startDate: self.startDate,
            endDate: self.endDate,
            position: self.$position.value as? String,
            companyName: self.$companyName.value as? String,
            companyLogo: self.$companyLogo.value as? String,
            status: self.$status.value as? String,
            missionDetails: self.$missionDetails.value as? String,
            degree: self.$degree.value as? String,
            misc: self.$misc.value as? String,
            skills: self.skills.compactMap({$0.id}),
            projects: self.projects.compactMap({$0.id})
        )
    }
}
