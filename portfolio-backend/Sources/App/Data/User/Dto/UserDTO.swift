import Fluent
import Vapor

typealias UsersDTO = [UserDTO]

struct UserDTO: Content {
    var id: UUID?
    var firstName: String?
    var lastName: String?
    var email: String
    var password: String?
    var role: UserRole

    func toModel() -> User {
        let model = User()
        model.id = self.id ?? UUID()
        model.firstName = self.firstName
        model.lastName = self.lastName
        model.email = self.email
        model.password = self.password ?? ""
        model.role = self.role
        return model
    }
}
