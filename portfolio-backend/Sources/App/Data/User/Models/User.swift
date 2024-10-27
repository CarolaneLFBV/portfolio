import Fluent
import Vapor

typealias UserRole = User.Role

final class User: Model, Content, @unchecked Sendable, Authenticatable {
    static let schema = "users"

    enum Role: String, Codable {
        case admin, member
    }

    @ID(key: .id)
    var id: UUID?

    @OptionalField(key: "imageURL")
    var imageURL: String?

    // TODO: Switch to optional
    @Group(key: "fullName")
    var fullName: FullName

    @Field(key: "role")
    var role: Role

    @Field(key: "email")
    var email: String

    @Field(key: "password")
    var password: String

    @OptionalField(key: "bio")
    var bio: String?

    @OptionalField(key: "introduction")
    var introduction: String?

    @OptionalField(key: "interests")
    var interests: [String]?

    init() {}

    init(
        id: UUID? = nil,
        imageURL: String,
        fullName: FullName,
        bio: String?,
        role: Role,
        email: String,
        password: String,
        introduction: String?,
        interests: [String]?
    ) {
            self.id = id
            self.imageURL = imageURL
            self.fullName = fullName
            self.bio = bio
            self.email = email
            self.password = password
            self.role = role
            self.introduction = introduction
            self.interests = interests
    }

    func toDTO() -> UserDTO {
        .init(
            id: self.id,
            imageURL: self.imageURL,
            fullName: self.fullName,
            role: self.role,
            email: self.email,
            password: nil,
            bio: self.bio,
            introduction: self.introduction,
            interests: self.interests
        )
    }

}

extension User {
    struct LoginCredentials: Content {
        var email: String
        var password: String
    }
}
