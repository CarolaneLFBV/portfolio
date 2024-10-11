import Fluent
import Vapor

typealias SkillsDTO = [SkillDTO]

struct SkillDTO: Content {
    var id: UUID?
    var name: String
    var tags: [String]
    var context: String
    var proofs: String
    var retrospective: String
    var progress: String
    var projects: [Project.IDValue]
    var experiences: [Experience.IDValue]

    func toModel() -> Skill {
        let model = Skill()

        model.id = self.id ?? UUID()
        model.name = self.name
        model.tags = self.tags
        model.context = self.context
        model.proofs = self.proofs
        model.retrospective = self.retrospective
        model.progress = self.progress

        return model
    }
}
