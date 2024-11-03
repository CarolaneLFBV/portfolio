import Vapor
import Fluent

extension Project.Repositories {
    struct ProjectRepository: Crudable {
        let db: Database
        typealias ProjectEntity = Project.Entity
        typealias SkillEntity = Skill.Entity
        typealias ExperienceEntity = Experience.Entity

        // Fetch all projects with associated projects and experiences
        func findAll() async throws -> [ProjectEntity] {
            try await ProjectEntity.query(on: db)
                .with(\.$skills)
                .with(\.$experiences)
                .all()
        }

        // Find a specific project by ID, including its related skills and experiences
        func find(_ id: UUID) async throws -> ProjectEntity? {
            try await ProjectEntity.query(on: db)
                .filter(\.$id == id)
                .with(\.$skills)
                .with(\.$experiences)
                .first()
        }

        // Create a new project and attach related skills and experiences
        func create(_ input: Project.Dto.Input) async throws {
            let project = input.toModel()
            try await project.save(on: db)

            if !input.skills.isEmpty {
                let skillModels = try await SkillEntity.query(on: db)
                    .filter(\.$id ~~ input.skills)
                    .all()
                try await project.$skills.attach(skillModels, on: db)
            }

            if !input.experiences.isEmpty {
                let experienceModels = try await ExperienceEntity.query(on: db)
                    .filter(\.$id ~~ input.experiences)
                    .all()
                try await project.$experiences.attach(experienceModels, on: db)
            }

            try await project.$skills.load(on: db)
            try await project.$experiences.load(on: db)
        }

        // Update an existing project, managing its skill and experience relationships
        func update(_ input: Project.Dto.Input) async throws {
            let project = input.toModel()
            try await project.$skills.load(on: db)
            try await project.$experiences.load(on: db)

            if input.skills.isEmpty {
                try await project.$skills.detachAll(on: db)
            } else {
                let skillModels = try await SkillEntity.query(on: db)
                    .filter(\.$id ~~ input.skills)
                    .all()
                try await project.$skills.detachAll(on: db)
                try await project.$skills.attach(skillModels, on: db)
            }

            if input.experiences.isEmpty {
                try await project.$experiences.detachAll(on: db)
            } else {
                let experienceModels = try await ExperienceEntity.query(on: db)
                    .filter(\.$id ~~ input.experiences)
                    .all()
                try await project.$experiences.detachAll(on: db)
                try await project.$experiences.attach(experienceModels, on: db)
            }

            try await project.update(on: db)
        }

        // Delete an existing project
        func delete(_ project: Project.Entity) async throws {
            try await project.delete(on: db)
        }
    }

}
