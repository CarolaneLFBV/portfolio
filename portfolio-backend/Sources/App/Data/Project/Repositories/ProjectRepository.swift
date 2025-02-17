import Vapor
import Fluent

extension Project.Repositories {
    struct ProjectRepository {
        let db: Database

        // Fetch all projects with associated projects and experiences
        func findAll() async throws -> [ProjectEntity] {
            try await ProjectEntity.query(on: db)
                .with(\.$skills)
                .with(\.$experiences)
                .all()
        }

        // Find a specific project by ID, including its related skills and experiences
        func find(_ slug: String) async throws -> ProjectEntity? {
            try await ProjectEntity.query(on: db)
                .filter(\.$slug == slug)
                .with(\.$skills)
                .with(\.$experiences)
                .first()
        }

        // Create a new project and attach related skills and experiences
        func create(_ input: Project.Dto.Input, on req: Request) async throws {
            let project = input.toModel()

            if let image = input.logo {
                let imageData = try await ImageUseCase().upload(image, on: req)
                project.logoUrl = imageData
            }

            try await project.save(on: db)
        }

        // Update an existing project, managing its skill and experience relationships
        func update(_ input: Project.Dto.Input, _ slug: String, on req: Request) async throws {
            guard let project = try await find(slug) else {
                throw Failed.idNotFound
            }

            project.name = input.name
            project.slug = input.name.slug()
            project.type = input.type
            project.link = input.link
            project.presentation = input.presentation

            if let newLogo = input.logo {
                if let oldLogo = project.logoUrl {
                    try await ImageUseCase().delete(at: oldLogo, on: req)
                }
                let logoPath = try await ImageUseCase().upload(newLogo, on: req)
                project.logoUrl = logoPath
            }

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
        func delete(_ slug: String, on req: Request) async throws {
            guard let project = try await find(slug) else {
                throw Failed.idNotFound
            }

            if let logo = project.logoUrl {
                try await ImageUseCase().delete(at: logo, on: req)
            }

            try await project.delete(on: db)
        }
    }
}
