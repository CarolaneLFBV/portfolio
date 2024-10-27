import Fluent
import Vapor

typealias ExperiencesDTO = [ExperienceDTO]

struct ExperienceDTO: Content {
    var id: UUID?
    var imageURL: String?
    var name: String
    var type: ExperienceType
    var introduction: String?
    var period: Period
    var companyName: String?
    var missionDetails: String?
    var skills: [Skill.IDValue]
    var projects: [Project.IDValue]

    func toModel() -> Experience {
        let model = Experience()
        model.id = self.id ?? UUID()
        model.imageURL = self.imageURL ?? ""
        model.name = self.name
        model.type = self.type
        model.introduction = self.introduction
        model.period = self.period
        model.companyName = self.companyName
        model.missionDetails = self.missionDetails
        return model
    }
}
