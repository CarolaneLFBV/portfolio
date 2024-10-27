import Fluent
import Vapor

final class Period: Fields, @unchecked Sendable {
    @Field(key: "startDate")
    var startDate: String

    @Field(key: "endDate")
    var endDate: String
}
