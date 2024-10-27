import Vapor
import Fluent

final class FullName: Fields, @unchecked Sendable {
    @OptionalField(key: "firstName")
    var firstName: String?

    @OptionalField(key: "lastName")
    var lastName: String?

}
