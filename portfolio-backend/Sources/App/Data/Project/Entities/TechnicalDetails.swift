import Fluent
import Vapor

extension Project.Entity {
    final class TechnicalDetails: Fields, @unchecked Sendable {
        @OptionalField(key: "choices")
        var technicalChoices: String?

        @OptionalField(key: "challenges")
        var challenges: String?

        @OptionalField(key: "solutions")
        var solutions: String?
    }
}
