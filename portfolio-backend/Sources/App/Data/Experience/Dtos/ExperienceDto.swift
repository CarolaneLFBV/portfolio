import Fluent
import Vapor

extension Experience.Dto {
    typealias ExperienceEntity = Experience.Entity
    typealias ExperienceType = Experience.Entity.ExperienceType
    typealias Period = Experience.Entity.Period
    typealias SkillIds = Skill.Entity.IDValue
    typealias ProjectIds = Project.Entity.IDValue
}
