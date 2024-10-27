import Fluent
import Vapor

typealias SituationType = ContextProject.SituationType

final class ContextProject: Fields, @unchecked Sendable {

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
