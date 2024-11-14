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

        @OptionalField(key: "firstName")
        var firstName: String?

        @OptionalField(key: "lastName")
        var lastName: String?

        @Field(key: "nickName")
        var nickName: String

        @Field(key: "slug")
        var slug: String

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
            firstName: String?,
            lastName: String?,
            nickName: String,
            slug: String,
            bio: String?,
            role: Role,
            email: String,
            password: String,
            introduction: String?,
            interests: [String]?
        ) {
                self.id = id
                self.imageURL = imageURL
                self.firstName = firstName
                self.lastName = lastName
                self.nickName = nickName
                self.slug = slug
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
    func toDto(from db: Database) throws -> User.Dto.Output {
        .init(
            id: id,
            imageURL: imageURL,
            firstName: firstName,
            lastName: lastName,
            nickName: nickName,
            slug: slug,
            role: role,
            email: email,
            bio: bio,
            introduction: introduction,
            interests: interests
        )
    }
}
