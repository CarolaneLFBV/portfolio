import Fluent
import Vapor

typealias UsersDTO = [UserDTO]

struct UserDTO: Content {
    var id: UUID?
    var imageURL: String?
    var fullName: FullName
    var role: UserRole
    var email: String
    var password: String?
    var bio: String?
    var introduction: String?
    var interests: [String]?

    func toModel() -> User {
        let model = User()
        model.id = self.id ?? UUID()
        model.imageURL = self.imageURL
        model.fullName = self.fullName
        model.email = self.email
        model.password = self.password ?? ""
        model.role = self.role
        model.bio = self.bio
        model.introduction = self.introduction
        model.interests = self.interests
        return model
    }
}
