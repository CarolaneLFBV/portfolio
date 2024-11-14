import Fluent
import Vapor

extension Skill.Repositories {
    struct SkillRepository {
        let db: Database

        // Fetch all skills with associated projects and experiences
        func findAll() async throws -> [SkillEntity] {
            try await SkillEntity.query(on: db)
                .with(\.$projects)
                .with(\.$experiences)
                .all()
        }

        // Find a specific skill by ID, including its related projects and experiences
        func find(_ slug: String) async throws -> SkillEntity? {
            try await SkillEntity.query(on: db)
                .filter(\.$slug == slug)
                .with(\.$projects)
                .with(\.$experiences)
                .first()
        }

        // Create a new skill and attach related projects and experiences
        func create(_ input: Skill.Dto.Input, on req: Request) async throws {
            let skill = input.toModel()

            if let image = input.image {
                let imageURL = try await ImageUseCase().upload(image, on: req)
                skill.imageURL = imageURL
            }

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

            try await skill.save(on: db)
        }

        // Update an existing skill, managing its project and experience relationships
        func update(_ input: Skill.Dto.Input, _ slug: String, on req: Request) async throws {
            guard let skill = try await find(slug) else {
                throw Failed.idNotFound
            }
            skill.name = input.name
            skill.slug = input.name.slug()
            skill.tags = input.tags
            skill.introduction = input.introduction
            skill.history = input.history

            if let image = input.image {
                let imageData = try await ImageUseCase().upload(image, on: req)
                skill.imageURL = imageData
            }

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

        // Delete an existing skill, including its associated image
         func delete(_ slug: String, req: Request) async throws {
             guard let skill = try await find(slug) else {
                 throw Failed.idNotFound
             }

             // Delete the associated image if it exists
             if let imageURL = skill.imageURL {
                 try await ImageUseCase().delete(at: imageURL, on: req)
             }

             // Delete the skill from the database
             try await skill.delete(on: db)
         }
    }
}
