import Fluent
import Vapor

typealias ExperiencesDTO = [ExperienceDTO]

struct ExperienceDTO: Content {
    var id: UUID?
    var type: ExperienceType
    var startDate: Date
    var endDate: Date
    var position: String?
    var companyName: String?
    var companyLogo: String?
    var status: String?
    var missionDetails: String?
    var skillID: UUID
    var projectID: UUID
    var degree: String?
    var misc: String?

    func toModel() -> Experience {
        let model = Experience()

        model.id = self.id
        model.type = self.type
        model.startDate = self.startDate
        model.endDate = self.endDate
        model.$skill.id = self.skillID
        model.$project.id = self.projectID

        if let position = self.position {
            model.position = position
        }
        if let status = self.status {
            model.status = status
        }
        if let missionDetails = self.missionDetails {
            model.missionDetails = missionDetails
        }
        if let degree = self.degree {
            model.degree = degree
        }
        if let misc = self.misc {
            model.misc = misc
        }
        if let companyLogo = self.companyLogo {
            model.companyLogo = companyLogo
        }
        if let companyName = self.companyName {
            model.companyName = companyName
        }

        return model
    }
}
