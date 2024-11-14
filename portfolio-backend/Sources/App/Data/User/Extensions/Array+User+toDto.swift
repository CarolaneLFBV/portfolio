import Foundation
import Fluent

extension Array where Element == User.Entity {
    func toDto(from db: Database) async throws -> [User.Dto.Output] {
        var usersArray: [User.Dto.Output] = []
        for user in self {
            guard let item = try? user.toDto(from: db) else {
                continue
            }
            usersArray.append(item)
        }
        return usersArray
    }
}
