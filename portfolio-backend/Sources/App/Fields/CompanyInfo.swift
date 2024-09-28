import Fluent
import Vapor

final class CompanyInfo: Fields, @unchecked Sendable {
    @Field(key: "companyName")
    var companyName: String

    @Field(key: "companyLogo")
    var companyLogo: String

    init() {}
}
