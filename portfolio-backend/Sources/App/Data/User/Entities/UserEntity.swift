import Vapor
import Fluent

typealias UserRole = User.Entity.Role

extension User {
    final class Entity: Model, Content, @unchecked Sendable, Authenticatable {
        static let schema = "users"

        enum Role: String, Codable {
            case admin, member
        }

        @ID(key: .id)
        var id: UUID?

        @OptionalField(key: "imageURL")
        var imageURL: String?

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
    }
}

extension User.Entity {
    struct LoginCredentials: Content {
        var email: String
        var password: String
    }
}
