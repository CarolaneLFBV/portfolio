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
        let introduction: String?
        let presentation: String?
        let background: Background
        let technicalDetails: TechnicalDetails
        let skills: [SkillIds]
        let experiences: [ExperienceIds]
    }
}
