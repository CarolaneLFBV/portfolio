import Vapor

extension Project.Dto {
    // Defines data that the API accepts.
    struct Input: Content {
        let name: String
        let images: [File]?
        let introduction: String?
        let presentation: String?
        let background: Background
        let technicalDetails: TechnicalDetails
        let skills: [SkillIds]
        let experiences: [ExperienceIds]

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: Project.Dto.Input.CodingKeys.self)
            let codingKeys = Project.Dto.Input.CodingKeys.self
            self.name = try container.decode(String.self, forKey: Project.Dto.Input.CodingKeys.name)
            self.images = try container.decodeIfPresent([File].self, forKey: codingKeys.images)
            self.introduction = try container.decodeIfPresent(String.self,
                                          forKey: codingKeys.introduction)
            self.presentation = try container.decodeIfPresent(String.self,
                                         forKey: codingKeys.presentation)
            self.background = try container.decode(Project.Dto.Background.self,
                                 forKey: codingKeys.background)
            self.technicalDetails = try container.decode(Project.Dto.TechnicalDetails.self,
                                 forKey: codingKeys.technicalDetails)
            self.skills = (try? container.decode([Project.Dto.SkillIds].self,
                                 forKey: codingKeys.skills)) ?? []
            self.experiences = (try? container.decode([Project.Dto.ExperienceIds].self,
                                forKey: codingKeys.experiences)) ?? []
        }

        func toModel() -> ProjectEntity {
            let project = ProjectEntity()
            project.name = self.name
            project.slug = self.name.slug()
            project.introduction = self.introduction
            project.presentation = self.presentation
            project.background = self.background
            project.technicalDetails = self.technicalDetails
            return project
        }
    }
}
