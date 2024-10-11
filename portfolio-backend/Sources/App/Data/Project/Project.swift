import Fluent
import Vapor

final class Project: Model, @unchecked Sendable {
    static let schema = "projects"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

    @Field(key: "presentation")
    var presentation: String

    @Field(key: "purpose")
    var purpose: String

    @Field(key: "milestone")
    var milestone: String

    @Field(key: "actor")
    var actor: String

    @Field(key: "progress")
    var progress: String

    @Siblings(through: ProjectSkill.self, from: \.$project, to: \.$skill)
    var skills: [Skill]

    @Siblings(through: ProjectExperience.self, from: \.$project, to: \.$experience)
    var experiences: [Experience]

    init() {}

    init(id: UUID? = nil,
         title: String,
         presentation: String,
         purpose: String,
         milestone: String,
         actor: String,
         progress: String) {
        self.id = id
        self.title = title
        self.presentation = presentation
        self.purpose = purpose
        self.milestone = milestone
        self.actor = actor
        self.progress = progress
    }

    func toDTO() -> ProjectDTO {
        .init(
            id: self.id,
            title: self.title,
            presentation: self.presentation,
            purpose: self.purpose,
            milestone: self.milestone,
            actor: self.actor,
            progress: self.progress,
            skills: self.skills.compactMap({$0.id}),
            experiences: self.experiences.compactMap({$0.id})
        )
    }
}
