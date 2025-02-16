import Fluent
import Vapor

extension Project.Entity {
    final class Background: Fields, @unchecked Sendable {
        @OptionalField(key: "issue")
        var problemStatement: String?

        @OptionalField(key: "role")
        var projectRole: String?

        @OptionalField(key: "goals")
        var achievedGoals: String?
    }
}
