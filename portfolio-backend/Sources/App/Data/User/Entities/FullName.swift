import Vapor
import Fluent

extension User.Entity {
    final class FullName: Fields, @unchecked Sendable {
        @OptionalField(key: "firstName")
        var firstName: String?

        @OptionalField(key: "lastName")
        var lastName: String?
    }
}
