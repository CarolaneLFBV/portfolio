import Fluent
import Vapor

extension Experience.Repositories {
    struct ExperienceRepository: Crudable {
        let db: Database
        typealias ProjectEntity = Project.Entity
        typealias SkillEntity = Skill.Entity
        typealias ExperienceEntity = Experience.Entity

        // Fetch all experience with associated projects and projects
        func findAll() async throws -> [ExperienceEntity] {
            try await ExperienceEntity.query(on: db)
                .with(\.$skills)
                .with(\.$projects)
                .all()
        }

        // Find a specific project by ID, including its related skills and $projects
        func find(_ id: UUID) async throws -> ExperienceEntity? {
            try await ExperienceEntity.query(on: db)
                .filter(\.$id == id)
                .with(\.$skills)
                .with(\.$projects)
                .first()
        }

        // Create a new experience and attach related skills and projects
        func create(_ input: Experience.Dto.Input) async throws {
            let experience = input.toModel()
            try await experience.save(on: db)

            if !input.skills.isEmpty {
                let skillModels = try await SkillEntity.query(on: db)
                    .filter(\.$id ~~ input.skills)
                    .all()
                try await experience.$skills.attach(skillModels, on: db)
            }

            if !input.projects.isEmpty {
                let projectModels = try await ProjectEntity.query(on: db)
                    .filter(\.$id ~~ input.projects)
                    .all()
                try await experience.$projects.attach(projectModels, on: db)
            }

            try await experience.$skills.load(on: db)
            try await experience.$projects.load(on: db)
        }

        // Update an existing experience, managing its skill and project relationships
        func update(_ input: Experience.Dto.Input) async throws {
            let experience = input.toModel()
            try await experience.$skills.load(on: db)
            try await experience.$projects.load(on: db)

            if input.skills.isEmpty {
                try await experience.$skills.detachAll(on: db)
            } else {
                let skills = try await SkillEntity.query(on: db)
                    .filter(\.$id ~~ input.skills)
                    .all()
                try await experience.$skills.detachAll(on: db)
                try await experience.$skills.attach(skills, on: db)
            }

            if input.projects.isEmpty {
                try await experience.$projects.detachAll(on: db)
            } else {
                let projects = try await ProjectEntity.query(on: db)
                    .filter(\.$id ~~ input.projects)
                    .all()
                try await experience.$projects.detachAll(on: db)
                try await experience.$projects.attach(projects, on: db)
            }
            try await experience.update(on: db)
        }

        // Delete an existing experience
        func delete(_ experience: ExperienceEntity) async throws {
            try await experience.delete(on: db)
        }
    }

}
