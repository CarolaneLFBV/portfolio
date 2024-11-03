import Vapor

extension Skill.Dto {
    // Defines data that the API accepts.
    struct Input: Content {
        let name: String
        let tags: [String]
        let introduction: Introduction
        let history: String?
        let projects: [ProjectIds]
        let experiences: [ExperienceIds]
        let image: File?
        var imagePath: String?

        func toModel() -> Skill.Entity {
            let skill = Skill.Entity()
            skill.name = self.name
            skill.tags = self.tags
            skill.introduction = self.introduction
            skill.history = self.history
            return skill
        }
    }
}
