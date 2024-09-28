import Vapor
import Fluent

enum Role: String, Codable {
    case admin, member
}
