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
            experience.imageUrls = []
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
            experience.period = input.period
            experience.companyName = input.companyName
            experience.missionDetails = input.missionDetails

            if let images = input.images, !images.isEmpty {
                let oldImages = experience.imageUrls ?? []
                for image in oldImages {
                    try await ImageUseCase().delete(at: image, on: req)
                }

                var imagePaths: [String] = []
                for image in images {
                    let imagePath = try await ImageUseCase().upload(image, on: req)
                    imagePaths.append(imagePath)
                }
                experience.imageUrls = imagePaths
            }

            if let newLogo = input.logo {
                if let oldLogo = experience.logoUrl {
                    try await ImageUseCase().delete(at: oldLogo, on: req)
                }
                let logoPath = try await ImageUseCase().upload(newLogo, on: req)
                experience.logoUrl = logoPath
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

            if let logo = experience.logoUrl {
                try await ImageUseCase().delete(at: logo, on: req)
            }

            for image in experience.imageUrls ?? [] {
                try await ImageUseCase().delete(at: image, on: req)
            }

            try await experience.delete(on: db)
        }
    }

}
