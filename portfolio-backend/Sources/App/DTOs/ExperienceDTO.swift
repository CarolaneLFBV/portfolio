import Fluent
import Vapor

typealias ExperiencesDTO = [ExperienceDTO]

struct ExperienceDTO: Content {
    var id: UUID?
    var type: ExperienceType
    var startDate: String
    var endDate: String
    var position: String?
    var companyName: String?
    var companyLogo: String?
    var status: String?
    var missionDetails: String?
    var degree: String?
    var misc: String?
    var skills: [Skill.IDValue]
    var projects: [Project.IDValue]

    func toModel() -> Experience {
        let model = Experience()

        model.id = self.id ?? UUID()
        model.type = self.type
        model.startDate = self.startDate
        model.endDate = self.endDate
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
