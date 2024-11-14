import Foundation
import Fluent

extension Array where Element == Skill.Entity {
    func toDto(from db: Database) async throws -> [Skill.Dto.Output] {
        var skillsArray: [Skill.Dto.Output] = []
        for skill in self {
            guard let item = try? await skill.toDTO(from: db) else {
                continue
            }
            skillsArray.append(item)
        }
        return skillsArray
    }
}
