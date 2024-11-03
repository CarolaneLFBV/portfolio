import Fluent
import Vapor

extension Skill.Repositories {
    struct SkillRepository: Crudable {
        let db: Database
        typealias SkillEntity = Skill.Entity
        typealias ProjectEntity = Project.Entity
        typealias ExperienceEntity = Experience.Entity

        // Fetch all skills with associated projects and experiences
        func findAll() async throws -> [SkillEntity] {
            try await SkillEntity.query(on: db)
                .with(\.$projects)
                .with(\.$experiences)
                .all()
        }

        // Find a specific skill by ID, including its related projects and experiences
        func find(_ id: UUID) async throws -> SkillEntity? {
            try await SkillEntity.query(on: db)
                .filter(\.$id == id)
                .with(\.$projects)
                .with(\.$experiences)
                .first()
        }

        // Create a new skill and attach related projects and experiences
        func create(_ input: Skill.Dto.Input) async throws {
            let skill = input.toModel()
            try await skill.save(on: db)

            if !input.projects.isEmpty {
                let projectModels = try await ProjectEntity.query(on: db)
                    .filter(\.$id ~~ input.projects)
                    .all()
                try await skill.$projects.attach(projectModels, on: db)
            }

            if !input.experiences.isEmpty {
                let experienceModels = try await ExperienceEntity.query(on: db)
                    .filter(\.$id ~~ input.experiences)
                    .all()
                try await skill.$experiences.attach(experienceModels, on: db)
            }
            try await skill.$projects.load(on: db)
            try await skill.$experiences.load(on: db)
        }

        // Update an existing skill, managing its project and experience relationships
        func update(_ input: Skill.Dto.Input) async throws {
            let skill = input.toModel()
            try await skill.$projects.load(on: db)
            try await skill.$experiences.load(on: db)

            if input.projects.isEmpty {
                try await skill.$projects.detachAll(on: db)
            } else {
                let projectModels = try await ProjectEntity.query(on: db)
                    .filter(\.$id ~~ input.projects)
                    .all()
                try await skill.$projects.detachAll(on: db)
                try await skill.$projects.attach(projectModels, on: db)
            }

            if input.experiences.isEmpty {
                try await skill.$experiences.detachAll(on: db)
            } else {
                let experienceModels = try await ExperienceEntity.query(on: db)
                    .filter(\.$id ~~ input.experiences)
                    .all()
                try await skill.$experiences.detachAll(on: db)
                try await skill.$experiences.attach(experienceModels, on: db)
            }

            try await skill.update(on: db)
        }

        // Delete an existing skill
        func delete(_ skill: SkillEntity) async throws {
            try await skill.delete(on: db)
        }
    }

}
