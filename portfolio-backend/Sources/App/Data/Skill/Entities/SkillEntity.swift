import Fluent
import Vapor

extension Skill {
    final class Entity: Model, @unchecked Sendable {
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
        var introduction: IntroductionEntity

        @OptionalField(key: "history")
        var history: String?

        @Siblings(through: ProjectSkill.self, from: \.$skill, to: \.$project)
        var projects: [Project.Entity]

        @Siblings(through: SkillExperience.self, from: \.$skill, to: \.$experience)
        var experiences: [Experience.Entity]

        init() {}

        init(id: UUID? = nil,
             imageURL: String? = nil,
             name: String,
             tags: [String],
             introduction: IntroductionEntity,
             history: String?) {
            self.id = id
            self.imageURL = imageURL
            self.name = name
            self.tags = tags
            self.introduction = introduction
            self.history = history
        }
    }
}

// extension Skill.Entity {
//    func convert() -> Skill.Dto.Output {
//        // .init(from: <#Skill.Entity#>)
//    }
// }
