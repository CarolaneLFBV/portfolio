import Fluent
import Vapor

typealias SkillsDTO = [SkillDTO]

struct SkillDTO: Content {
    var id: UUID?
    var imageURL: String?
    var name: String
    var tags: [String]
    var introduction: Introduction
    var history: String?
    var projects: [Project.IDValue]
    var experiences: [Experience.IDValue]

    func toModel() -> Skill {
        let model = Skill()

        model.id = self.id ?? UUID()
        model.imageURL = self.imageURL ?? ""
        model.name = self.name
        model.tags = self.tags
        model.introduction = self.introduction
        model.history = self.history
        return model
    }
}
