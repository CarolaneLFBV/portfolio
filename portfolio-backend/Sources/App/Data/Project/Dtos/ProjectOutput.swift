import Vapor

extension Project.Dto {
    // Represents the data format that the API will return to the client.
    struct Output: Content {
        let id: UUID?
        let imageUrls: [String]?
        let logoUrl: String?
        let name: String
        let slug: String?
        let type: ProjectType
        let presentation: String?
        let skills: [SkillIds]
        let experiences: [ExperienceIds]
    }
}
