import Fluent
import Vapor

final class ProjectSkill: Model, @unchecked Sendable {
    static let schema = "project+skill"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "project_id")
    var project: Project

    @Parent(key: "skill_id")
    var skill: Skill

    init() {}

    init(id: UUID? = nil,
         project: Project,
         skill: Skill) throws {
        self.id = id
        self.$project.id = try project.requireID()
        self.$skill.id = try skill.requireID()
    }
}
