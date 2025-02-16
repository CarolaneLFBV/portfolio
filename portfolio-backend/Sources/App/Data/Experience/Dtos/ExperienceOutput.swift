import Vapor

extension Experience.Dto {
    // Represents the data format that the API will return to the client.
    struct Output: Content {
        let id: UUID?
        let imageUrls: [String]?
        let logoUrl: String?
        let name: String
        let slug: String?
        let type: ExperienceType
        let period: Period
        let companyName: String?
        let missionDetails: [String]?
        let skills: [SkillIds]
        let projects: [ProjectIds]
    }
}
