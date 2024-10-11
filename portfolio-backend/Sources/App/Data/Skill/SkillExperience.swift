import Fluent
import Vapor

final class SkillExperience: Model, @unchecked Sendable {
    static let schema = "skill+experience"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "skill_id")
    var skill: Skill

    @Parent(key: "experience_id")
    var experience: Experience

    init() {}

    init(id: UUID? = nil,
         skill: Skill,
         experience: Experience) throws {
        self.id = id
        self.$skill.id = try skill.requireID()
        self.$experience.id = try experience.requireID()
    }
}
