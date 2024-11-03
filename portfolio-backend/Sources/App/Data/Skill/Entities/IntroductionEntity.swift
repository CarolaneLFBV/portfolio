import Vapor
import Fluent

extension Skill.Entity {
    final class IntroductionEntity: Fields, @unchecked Sendable {
        @OptionalField(key: "definition")
        var definition: String?

        @OptionalField(key: "context")
        var context: String?
    }

}
