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

        model.id = self.id ?? UUID()
        model.type = self.type
        model.startDate = self.startDate
        model.endDate = self.endDate
        model.$skill.id = self.skillID
        model.$project.id = self.projectID
        model.position = self.position
        model.status = self.status
        model.missionDetails = self.missionDetails
        model.degree = self.degree
        model.misc = self.misc
        model.companyLogo = self.companyLogo
        model.companyName = self.companyName

        return model
    }
}
