import Fluent
import Vapor

extension Project.Dto {
    typealias ProjectEntity = Project.Entity
    typealias SkillIds = Skill.Entity.IDValue
    typealias ExperienceIds = Experience.Entity.IDValue
}
