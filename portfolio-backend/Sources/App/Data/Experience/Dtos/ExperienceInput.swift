import Vapor

extension Experience.Dto {
    // Defines data that the API accepts.
    struct Input: Content {
        let name: String
        let type: ExperienceType
        let introduction: String?
        let period: Period
        let companyName: String?
        let missionDetails: String?
        let skills: [SkillIds]
        let projects: [ProjectIds]
        var images: [File]?
        var logo: File?

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: Experience.Dto.Input.CodingKeys.self)
            let codingKeys = Experience.Dto.Input.CodingKeys.self

            self.name = try container.decode(String.self,
                                             forKey: codingKeys.name)
            self.type = try container.decode(Experience.Dto.ExperienceType.self,
                                             forKey: codingKeys.type)
            self.introduction = try container.decodeIfPresent(String.self,
                                                              forKey: codingKeys.introduction)
            self.period = try container.decode(Experience.Dto.Period.self,
                                               forKey: codingKeys.period)
            self.companyName = try container.decodeIfPresent(String.self,
                                                             forKey: codingKeys.companyName)
            self.missionDetails = try container.decodeIfPresent(String.self,
                                                                forKey: codingKeys.missionDetails)
            self.skills = (try? container.decode([Experience.Dto.SkillIds].self,
                                                 forKey: codingKeys.skills)) ?? []
            self.projects = (try? container.decode([Experience.Dto.ProjectIds].self,
                                                   forKey: codingKeys.projects)) ?? []
            self.images = try container.decodeIfPresent([File].self,
                                                        forKey: codingKeys.images)
            self.logo = try container.decodeIfPresent(File.self, forKey: codingKeys.logo)
        }

        func toModel() -> ExperienceEntity {
            let experience = ExperienceEntity()
            experience.name = self.name
            experience.slug = self.name.slug()
            experience.type = self.type
            experience.introduction = self.introduction
            experience.period = self.period
            experience.companyName = self.companyName
            experience.missionDetails = self.missionDetails
            return experience
        }
    }
}
