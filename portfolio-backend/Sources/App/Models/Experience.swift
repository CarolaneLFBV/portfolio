import Fluent
import Foundation

final class Experience: Model, @unchecked Sendable {
    static let schema = "experiences"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "type")
    var type: ExperienceType

    @Field(key: "startDate")
    var startDate: Date

    @Field(key: "endDate")
    var endDate: Date

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

    @Parent(key: "skillID")
    var skill: Skill

    @Parent(key: "projectID")
    var project: Project

    @Field(key: "degree")
    var degree: String?

    @Field(key: "misc")
    var misc: String?

    init() {}

    init(id: UUID? = nil,
         type: ExperienceType,
         startDate: Date,
         endDate: Date,
         position: String,
         status: String,
         missionDetails: String,
         degree: String,
         misc: String,
         skillID: UUID,
         projectID: UUID,
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
            self.$skill.id = skillID
            self.$project.id = projectID
            self.companyName = companyName
            self.companyLogo = companyLogo
       }

    func toDTO() -> ExperienceDTO {
        .init(
            id: self.id,
            type: self.type,
            startDate: self.startDate,
            endDate: self.endDate,
            position: self.position,
            companyName: self.companyName,
            companyLogo: self.companyLogo,
            status: self.status,
            missionDetails: self.missionDetails,
            skillID: self.$skill.id,
            projectID: self.$project.id,
            degree: self.degree,
            misc: self.misc
        )
    }
}

extension Experience {
    enum Category: String, Codable {
        case professionnal, education
    }
}
