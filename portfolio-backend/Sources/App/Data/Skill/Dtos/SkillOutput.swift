import Vapor

extension Skill.Dto {
    // Represents the data format that the API will return to the client.
    struct Output: Content {
        let id: UUID?
        let name: String
        let slug: String
        let type: SkillType
        let tags: [String]
        let introduction: Introduction
        let history: String?
        let imageURL: String?
        let projects: [ProjectIds]
        let experiences: [ExperienceIds]
    }
}
