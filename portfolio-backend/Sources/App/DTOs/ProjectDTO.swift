import Fluent
import Vapor

struct ProjectDTO: Content {
    var id: UUID?
    var title: String
    var presentation: String
    var purpose: String
    var milestone: String
    var actor: String
    var progress: String
    var skillID: UUID

    func toModel() -> Project {
        let model = Project()

        model.id = self.id
        model.title = self.title
        model.presentation = self.presentation
        model.purpose = self.purpose
        model.milestone = self.milestone
        model.actor = self.actor
        model.progress = self.progress
        model.$skill.id = self.skillID

        return model
    }
}