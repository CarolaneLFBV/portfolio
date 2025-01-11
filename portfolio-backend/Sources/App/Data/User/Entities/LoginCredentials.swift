import Foundation
import Vapor

extension User.Entity {
    struct LoginCredentials: Content {
        let email: String
        let password: String
    }
}
