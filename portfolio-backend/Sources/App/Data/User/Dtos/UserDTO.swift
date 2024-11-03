import Fluent
import Vapor

extension User.Dto {
    typealias FullName = User.Entity.FullName
    struct Input: Content {
        var image: File?
        var fullName: FullName
        var role: UserRole
        var email: String
        var password: String?
        var bio: String?
        var introduction: String?
        var interests: [String]?

        func toModel() -> User.Entity {
            let model = User.Entity()
            model.fullName = self.fullName
            model.role = self.role
            model.email = self.email
            model.password = self.password ?? ""
            model.bio = self.bio
            model.introduction = self.introduction
            model.interests = self.interests
            return model
        }
    }

    struct Output: Content {
        var id: UUID?
        var imageURL: String?
        var fullName: FullName
        var role: UserRole
        var email: String
        var bio: String?
        var introduction: String?
        var interests: [String]?

        init(from user: User.Entity) {
            self.id = user.id
            self.imageURL = user.imageURL
            self.fullName = user.fullName
            self.role = user.role
            self.email = user.email
            self.bio = user.bio
            self.introduction = user.introduction
            self.interests = user.interests
        }
    }
}
