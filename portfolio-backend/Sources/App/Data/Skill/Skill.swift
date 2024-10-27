import Fluent
import Vapor

final class Skill: Model, @unchecked Sendable {
    static let schema = "skills"

    @ID(key: .id)
    var id: UUID?

    @OptionalField(key: "imageURL")
    var imageURL: String?

    @Field(key: "name")
    var name: String

    @Field(key: "tags")
    var tags: [String]

    @Group(key: "introduction")
    var introduction: Introduction

    @OptionalField(key: "history")
    var history: String?

    @Siblings(through: ProjectSkill.self, from: \.$skill, to: \.$project)
    var projects: [Project]

    @Siblings(through: SkillExperience.self, from: \.$skill, to: \.$experience)
    var experiences: [Experience]

    init() {}

    init(id: UUID? = nil,
         imageURL: String? = nil,
         name: String,
         tags: [String],
         introduction: Introduction,
         history: String?) {
        self.id = id
        self.imageURL = imageURL
        self.name = name
        self.tags = tags
        self.introduction = introduction
        self.history = history
    }

    func toDTO() -> SkillDTO {
        .init(
            id: self.id,
            imageURL: self.imageURL,
            name: self.name,
            tags: self.tags,
            introduction: self.introduction,
            history: self.history,
            projects: self.projects.compactMap({$0.id}),
            experiences: self.experiences.compactMap({$0.id})
        )
    }
}
