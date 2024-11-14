import Foundation
import Fluent

extension Array where Element == Project.Entity {
    func toDto(from db: Database) async throws -> [Project.Dto.Output] {
        var projectArray: [Project.Dto.Output] = []
        for project in self {
            guard let item = try? await project.toDTO(from: db) else {
                continue
            }
            projectArray.append(item)
        }
        return projectArray
    }
}
