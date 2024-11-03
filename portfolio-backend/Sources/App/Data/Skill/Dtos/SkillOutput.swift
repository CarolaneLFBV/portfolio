import Vapor

extension Skill.Dto {
    // Represents the data format that the API will return to the client.
    struct Output: Content {
        let id: UUID?
        let name: String
        let tags: [String]
        let introduction: Introduction
        let history: String?
        let imageURL: String?
        let projects: [ProjectIds]
        let experiences: [ExperienceIds]

        init(from skill: Skill.Entity) {
            self.id = skill.id
            self.name = skill.name
            self.tags = skill.tags
            self.introduction = skill.introduction
            self.history = skill.history
            self.imageURL = skill.imageURL
            self.projects = skill.projects.compactMap { $0.id }
            self.experiences = skill.experiences.compactMap { $0.id }
        }
    }
}
