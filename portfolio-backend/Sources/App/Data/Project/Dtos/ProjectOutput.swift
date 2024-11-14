import Vapor

extension Project.Dto {
    // Represents the data format that the API will return to the client.
    struct Output: Content {
        let id: UUID?
        let imageURLs: [String]?
        let name: String
        let slug: String?
        let introduction: String?
        let presentation: String?
        let background: Background
        let technicalDetails: TechnicalDetails
        let skills: [SkillIds]
        let experiences: [ExperienceIds]
    }
}
