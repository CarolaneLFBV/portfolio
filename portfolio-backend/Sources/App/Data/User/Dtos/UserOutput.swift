import Foundation
import Vapor

extension User.Dto {
    struct Output: Content {
        let id: UUID?
        let imageURL: String?
        let firstName: String?
        let lastName: String?
        let nickName: String
        let slug: String
        let role: UserRole
        let email: String
        let bio: String?
    }
}
