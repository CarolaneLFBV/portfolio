import Vapor

extension Project.Dto {
    // Defines data that the API accepts.
    struct Input: Content {
        let name: String
        let logo: File?
        let type: ProjectType
        let link: String?
        let presentation: String?
        let skills: [SkillIds]
        let experiences: [ExperienceIds]

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: Project.Dto.Input.CodingKeys.self)
            let codingKeys = Project.Dto.Input.CodingKeys.self
            self.name = try container.decode(String.self, forKey: codingKeys.name)
            self.type = try container.decode(ProjectType.self, forKey: codingKeys.type)
            self.link = try container.decodeIfPresent(String.self, forKey: codingKeys.link)
            self.logo = try container.decodeIfPresent(File.self, forKey: codingKeys.logo)
            self.presentation = try container.decodeIfPresent(String.self, forKey: codingKeys.presentation)
            self.skills = (try? container.decode([Project.Dto.SkillIds].self, forKey: codingKeys.skills)) ?? []
            self.experiences = (try? container.decode([Project.Dto.ExperienceIds].self, forKey: codingKeys.experiences)) ?? []
        }

        func toModel() -> ProjectEntity {
            let project = ProjectEntity()
            project.name = self.name
            project.slug = self.name.slug()
            project.type = self.type
            project.link = self.link
            project.presentation = self.presentation
            return project
        }
    }
}
