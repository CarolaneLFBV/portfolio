import Fluent
import Vapor

typealias SituationType = Project.Entity.Background.SituationType

extension Project.Entity {
    final class Background: Fields, @unchecked Sendable {
        enum SituationType: String, Codable {
            case professional, training, personal
        }

        @OptionalField(key: "situation")
        var situation: SituationType?

        @OptionalField(key: "issue")
        var problemStatement: String?

        @OptionalField(key: "role")
        var projectRole: String?

        @OptionalField(key: "goals")
        var achievedGoals: String?
    }
}
