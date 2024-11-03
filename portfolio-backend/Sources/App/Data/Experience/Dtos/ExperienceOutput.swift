import Vapor

extension Experience.Dto {
    // Represents the data format that the API will return to the client.
    struct Output: Content {
        var id: UUID?
        var imageURLs: [String]?
        var name: String
        var type: ExperienceType
        var introduction: String?
        var period: Period
        var companyName: String?
        var missionDetails: String?
        var skills: [UUID]
        var projects: [UUID]

        init(from experience: ExperienceEntity) {
            self.id = experience.id
            self.imageURLs = experience.imageURLs
            self.name = experience.name
            self.type = experience.type
            self.introduction = experience.introduction
            self.period = experience.period
            self.companyName = experience.companyName
            self.missionDetails = experience.missionDetails
            self.skills = experience.skills.compactMap { $0.id }
            self.projects = experience.projects.compactMap { $0.id }
        }
    }
}
