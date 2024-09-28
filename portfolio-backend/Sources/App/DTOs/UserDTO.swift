import Fluent
import Vapor

struct UserDTO: Content {
    var id: UUID?
    var firstName: String?
    var lastName: String?
    var email: String
    var password: String?
    var role: Role

    func toModel() -> User {
        let model = User()
        model.id = self.id
        model.email = self.email
        model.password = self.password ?? ""
        model.role = self.role

        if let firstName = model.firstName {
            model.firstName = firstName
        }
        if let lastName = model.lastName {
            model.lastName = lastName
        }
        return model
    }
}
