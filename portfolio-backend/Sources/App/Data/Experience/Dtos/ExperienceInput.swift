import Vapor

extension Experience.Dto {
    // Defines data that the API accepts.
    struct Input: Content {
        var name: String
        var type: ExperienceType
        var introduction: String?
        var period: Period
        var companyName: String?
        var missionDetails: String?
        var skills: [SkillIds]
        var projects: [ProjectIds]
        var images: [File]?

        func toModel() -> ExperienceEntity {
            let experience = ExperienceEntity()
            experience.name = self.name
            experience.type = self.type
            experience.introduction = self.introduction
            experience.period = self.period
            experience.companyName = self.companyName
            experience.missionDetails = self.missionDetails
            return experience
        }
    }
}
