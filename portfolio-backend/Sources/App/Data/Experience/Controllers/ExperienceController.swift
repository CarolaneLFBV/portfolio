import Fluent
import Vapor

extension Experience.Controllers {
    struct Config: RouteCollection {
        typealias ExperienceRepository = Experience.Repositories.ExperienceRepository
        typealias ExperienceInput = Experience.Dto.Input
        typealias ExperienceOutput = Experience.Dto.Output
        private let repository: ExperienceRepository

        init(repository: ExperienceRepository) {
            self.repository = repository
        }

        func boot(routes: any RoutesBuilder) throws {
            let experiences = routes.grouped("experiences")
            let experience = experiences.grouped(":experienceId")
            experiences.get(use: self.index)
            experience.get(use: self.getExperience)

            let protected = experiences.grouped([
                User.Middlewares.JWTAuthAuthenticator(),
                User.Middlewares.RoleMiddleware(requiredRole: .admin),
                User.Entity.guardMiddleware()])
            protected.post("create", use: self.create)

            let protectedElement = protected.grouped(":experienceId")
            protectedElement.patch(use: self.update)
            protectedElement.delete(use: self.delete)
        }
    }
}

extension Experience.Controllers.Config {
    // Fetch all experiences from repository call
    @Sendable
    func index(req: Request) async throws -> [ExperienceOutput] {
        let experiences = try await repository.findAll()
        return experiences.map { ExperienceOutput(from: $0) }
    }

    // Find a specific experience from repository call
    @Sendable
    func getExperience(req: Request) async throws -> ExperienceOutput {
        guard let experienceId = req.parameters.get("experienceId", as: UUID.self),
              let experience = try await repository.find(experienceId) else {
            throw Failed.idNotFound
        }
        return ExperienceOutput(from: experience)
    }

    // Create a new experience from repository call
    @Sendable
    func create(req: Request) async throws -> ExperienceOutput {
        let experienceInput = try req.content.decode(ExperienceInput.self)
        let experience = experienceInput.toModel()

        if let images = experienceInput.images {
            var imagePaths: [String] = []

            for image in images {
                let imagePath = try await ImageUseCase().upload(image, on: req)
                imagePaths.append(imagePath)
            }

            experience.imageURLs = imagePaths
        }

        try await repository.create(experienceInput)
        return ExperienceOutput(from: experience)
    }

    // Update an existing project from repository call
    @Sendable
    func update(req: Request) async throws -> ExperienceOutput {
        guard let experienceId = req.parameters.get("experienceId", as: UUID.self),
              let experience = try await repository.find(experienceId) else {
            throw Abort(.notFound)
        }

        let updatedExperience = try req.content.decode(ExperienceInput.self)
        experience.name = updatedExperience.name
        experience.type = updatedExperience.type
        experience.introduction = updatedExperience.introduction
        experience.period = updatedExperience.period
        experience.companyName = updatedExperience.companyName
        experience.missionDetails = updatedExperience.missionDetails

        if let images = updatedExperience.images {
            var imagePaths: [String] = []

            for image in images {
                let imagePath = try await ImageUseCase().upload(image, on: req)
                imagePaths.append(imagePath)
            }

            experience.imageURLs = imagePaths
        }

        try await repository.update(updatedExperience)
        return ExperienceOutput(from: experience)
    }

    // Delete existing experience from repository call
    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let experienceId = req.parameters.get("experienceId", as: UUID.self),
                let experience = try await repository.find(experienceId) else {
            throw Failed.idNotFound
        }

        try await repository.delete(experience)
        return .noContent
    }

}
