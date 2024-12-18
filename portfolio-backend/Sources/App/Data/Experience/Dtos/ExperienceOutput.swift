import Vapor

extension Experience.Dto {
    // Represents the data format that the API will return to the client.
    struct Output: Content {
        let id: UUID?
        let imageURLs: [String]?
        let name: String
        let slug: String?
        let type: ExperienceType
        let introduction: String?
        let period: Period
        let companyName: String?
        let missionDetails: String?
        let skills: [SkillIds]
        let projects: [ProjectIds]
    }
}
