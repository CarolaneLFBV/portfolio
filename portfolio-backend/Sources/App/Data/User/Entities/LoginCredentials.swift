import Foundation
import Vapor

extension User.Entity {
    struct LoginCredentials: Content {
        var email: String
        var password: String
    }
}
