import Fluent
import Vapor

extension Project.Dto {
    typealias ProjectEntity = Project.Entity
    typealias TechnicalDetails = Project.Entity.TechnicalDetails
    typealias Background = Project.Entity.Background
    typealias SkillIds = Skill.Entity.IDValue
    typealias ExperienceIds = Experience.Entity.IDValue
}
