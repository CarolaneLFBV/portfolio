import Vapor

extension Project.Dto {
    // Represents the data format that the API will return to the client.
    struct Output: Content {
        var id: UUID?
        var imageURLs: [String]?
        var name: String
        var introduction: String?
        var presentation: String?
        var background: Background
        var technicalDetails: TechnicalDetails
        var skills: [SkillIds]
        var experiences: [ExperienceIds]

        init(from project: ProjectEntity) {
            self.id = project.id
            self.imageURLs = project.imageURLs
            self.name = project.name
            self.introduction = project.introduction
            self.presentation = project.presentation
            self.background = project.background
            self.technicalDetails = project.technicalDetails
            self.skills = project.skills.compactMap { $0.id }
            self.experiences = project.experiences.compactMap { $0.id }
        }
    }
}
