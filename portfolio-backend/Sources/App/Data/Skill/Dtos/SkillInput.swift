import Vapor

extension Skill.Dto {
    // Defines data that the API accepts.
    struct Input: Content {
        let name: String
        let tags: [String]
        let projects: [ProjectIds]
        let experiences: [ExperienceIds]
        let image: File?
        var imagePath: String?

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: Skill.Dto.Input.CodingKeys.self)
            self.name = try container.decode(String.self, forKey: Skill.Dto.Input.CodingKeys.name)
            self.tags = try container.decode([String].self, forKey: Skill.Dto.Input.CodingKeys.tags)
            self.projects = (try? container.decode([Skill.Dto.ProjectIds].self, forKey: Skill.Dto.Input.CodingKeys.projects)) ?? []
            self.experiences = (try? container.decode([Skill.Dto.ExperienceIds].self, forKey: Skill.Dto.Input.CodingKeys.experiences)) ?? []
            self.image = try container.decodeIfPresent(File.self, forKey: Skill.Dto.Input.CodingKeys.image)
            self.imagePath = try container.decodeIfPresent(String.self, forKey: Skill.Dto.Input.CodingKeys.imagePath)
        }

        func toModel() -> Skill.Entity {
            let skill = Skill.Entity()
            skill.name = self.name
            skill.slug = self.name.slug()
            skill.tags = self.tags
            return skill
        }
    }
}
