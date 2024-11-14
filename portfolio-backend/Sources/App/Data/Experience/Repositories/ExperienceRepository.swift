import Fluent
import Vapor

extension Experience.Repositories {
    struct ExperienceRepository {
        let db: Database

        // Fetch all experience with associated projects and projects
        func findAll() async throws -> [ExperienceEntity] {
            try await ExperienceEntity.query(on: db)
                .with(\.$skills)
                .with(\.$projects)
                .all()
        }

        // Find a specific project by ID, including its related skills and $projects
        func find(_ slug: String) async throws -> ExperienceEntity? {
            try await ExperienceEntity.query(on: db)
                .filter(\.$slug == slug)
                .with(\.$skills)
                .with(\.$projects)
                .first()
        }

        // Create a new experience and attach related skills and projects
        func create(_ input: Experience.Dto.Input, on req: Request) async throws {
            let experience = input.toModel()
            experience.imageURLs = []

            if let images = input.images {
                var imagePaths: [String] = []

                for image in images {
                    let imagePath = try await ImageUseCase().upload(image, on: req)
                    imagePaths.append(imagePath)
                }

                experience.imageURLs = imagePaths
            }

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

            try await experience.save(on: db)
        }

        // Update an existing experience, managing its skill and project relationships
        func update(_ input: Experience.Dto.Input, _ slug: String, on req: Request) async throws {
            guard let experience = try await find(slug) else {
                throw Failed.idNotFound
            }
            experience.name = input.name
            experience.slug = input.name.slug()
            experience.type = input.type
            experience.introduction = input.introduction
            experience.period = input.period
            experience.companyName = input.companyName
            experience.missionDetails = input.missionDetails

            if let images = input.images {
                var imagePaths: [String] = []

                for image in images {
                    let imagePath = try await ImageUseCase().upload(image, on: req)
                    imagePaths.append(imagePath)
                }

                experience.imageURLs = imagePaths
            }

            if input.skills.isEmpty {
                try await experience.$skills.detachAll(on: db)
            } else {
                let skillModels = try await SkillEntity.query(on: db)
                    .filter(\.$id ~~ input.skills)
                    .all()
                try await experience.$skills.detachAll(on: db)
                try await experience.$skills.attach(skillModels, on: db)
            }

            if input.projects.isEmpty {
                try await experience.$projects.detachAll(on: db)
            } else {
                let projectsModels = try await ProjectEntity.query(on: db)
                    .filter(\.$id ~~ input.projects)
                    .all()
                try await experience.$projects.detachAll(on: db)
                try await experience.$projects.attach(projectsModels, on: db)
            }
            try await experience.update(on: db)
        }

        // Delete an existing experience
        func delete(_ slug: String, on req: Request) async throws {
            guard let experience = try await find(slug) else {
                throw Failed.idNotFound
            }

            if let images = experience.imageURLs {
                for image in images {
                    try await ImageUseCase().delete(at: image, on: req)
                }
            }
            try await experience.delete(on: db)
        }
    }

}
