import Foundation
import Fluent

extension Array where Element == Experience.Entity {
    func toDto(from db: Database) async throws -> [Experience.Dto.Output] {
        var experiencesArray: [Experience.Dto.Output] = []
        for experience in self {
            guard let item = try? await experience.toDTO(from: db) else {
                continue
            }
            experiencesArray.append(item)
        }
        return experiencesArray
    }
}
