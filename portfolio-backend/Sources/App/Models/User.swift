import Fluent
import Vapor

final class User: Model, Content, @unchecked Sendable, Authenticatable {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "firstName")
    var firstName: String?

    @Field(key: "lastName")
    var lastName: String?

    @Field(key: "email")
    var email: String

    @Field(key: "password")
    var password: String

    @Field(key: "role")
    var role: Role

    init() {}

    init(id: UUID? = nil, firstName: String, lastName: String, email: String, password: String, role: Role) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
        self.role = role
    }

    func toDTO() -> UserDTO {
        .init(
            id: self.id,
            firstName: self.$firstName.value as? String,
            lastName: self.$lastName.value as? String,
            email: self.email,
            password: nil,
            role: self.role
        )
    }

}

extension User {
    struct LoginCredentials: Content {
        var email: String
        var password: String
    }

    struct TokenResponse: Content {
        let user: UserDTO
        let token: String
    }
}
