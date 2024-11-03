import Vapor

extension Project.Dto {
    // Defines data that the API accepts.
    struct Input: Content {
        var name: String
        var images: [File]?
        var introduction: String?
        var presentation: String?
        var background: Background
        var technicalDetails: TechnicalDetails
        var skills: [SkillIds]
        var experiences: [ExperienceIds]

        func toModel() -> ProjectEntity {
            let project = ProjectEntity()
            project.name = self.name
            project.introduction = self.introduction
            project.presentation = self.presentation
            project.background = self.background
            project.technicalDetails = self.technicalDetails
            return project
        }
    }
}
