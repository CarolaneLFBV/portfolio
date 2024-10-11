import Fluent
import Vapor

final class ProjectExperience: Model, @unchecked Sendable {
    static let schema = "project+experience"

    @ID(key: .id)
    var id: UUID?

    @Parent(key: "project_id")
    var project: Project

    @Parent(key: "experience_id")
    var experience: Experience

    init() {}

    init(id: UUID? = nil,
         project: Project,
         experience: Experience) throws {
        self.id = id
        self.$project.id = try project.requireID()
        self.$experience.id = try experience.requireID()
    }
}
