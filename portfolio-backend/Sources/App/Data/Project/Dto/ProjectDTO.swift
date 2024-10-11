import Fluent
import Vapor

typealias ProjectsDTO = [ProjectDTO]

struct ProjectDTO: Content {
    var id: UUID?
    var title: String
    var presentation: String
    var purpose: String
    var milestone: String
    var actor: String
    var progress: String
    var skills: [Skill.IDValue]
    var experiences: [Experience.IDValue]

    func toModel() -> Project {
        let model = Project()

        model.id = self.id ?? UUID()
        model.title = self.title
        model.presentation = self.presentation
        model.purpose = self.purpose
        model.milestone = self.milestone
        model.actor = self.actor
        model.progress = self.progress

        return model
    }
}
