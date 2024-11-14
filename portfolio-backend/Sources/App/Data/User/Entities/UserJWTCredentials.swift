import Foundation
import Vapor
import Fluent

extension User.Entity {
    struct UserJWTCredentials: Content, Authenticatable {
        let id: UUID?
        let role: UserRole
    }
}
