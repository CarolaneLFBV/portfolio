import Fluent
import Foundation

final class Skill: Model, @unchecked Sendable {
    static let schema = "skills"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "name")
    var name: String

    @Field(key: "tags")
    var tags: [String]

    @Field(key: "context")
    var context: String

    @Field(key: "proofs")
    var proofs: String

    @Field(key: "retrospective")
    var retrospective: String

    @Field(key: "progress")
    var progress: String

    init() {}

    init(id: UUID? = nil,
         name: String,
         tags: [String],
         context: String,
         proofs: String,
         retrospective: String,
         progress: String) {
        self.id = id
        self.name = name
        self.tags = tags
        self.context = context
        self.proofs = proofs
        self.retrospective = retrospective
        self.progress = progress
    }

    func toDTO() -> SkillDTO {
        .init(
            id: self.id,
            name: self.name,
            tags: self.tags,
            context: self.context,
            proofs: self.proofs,
            retrospective: self.retrospective,
            progress: self.progress
        )
    }
}
