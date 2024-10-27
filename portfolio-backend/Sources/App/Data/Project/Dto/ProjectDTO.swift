import Fluent
import Vapor

typealias ProjectsDTO = [ProjectDTO]

struct ProjectDTO: Content {
    var id: UUID?
    var imageURL: String?
    var name: String
    var introduction: String?
    var presentation: String?
    var context: ContextProject
    var technicalDetails: TechnicalDetails
    var skills: [Skill.IDValue]
    var experiences: [Experience.IDValue]

    func toModel() -> Project {
        let model = Project()

        model.id = self.id ?? UUID()
        model.imageURL = self.imageURL
        model.name = self.name
        model.introduction = self.introduction
        model.presentation = self.presentation
        model.context = self.context
        model.technicalDetails = self.technicalDetails

        return model
    }
}
