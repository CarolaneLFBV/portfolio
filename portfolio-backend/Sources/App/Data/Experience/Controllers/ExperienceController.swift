import Fluent
import Vapor

struct ExperienceController: RouteCollection {
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
            JWTAuthAuthenticator(),
            RoleMiddleware(requiredRole: .admin),
            User.guardMiddleware()])
        protected.post("create", use: self.create)

        let protectedElement = protected.grouped(":experienceId")
        protectedElement.patch(use: self.update)
        protectedElement.delete(use: self.delete)
    }
}

extension ExperienceController {
    @Sendable
    func index(req: Request) async throws -> ExperiencesDTO {
        let experiences = try await repository.findAll()
        return experiences.map { $0.toDTO() }
    }

    @Sendable
    func getExperience(req: Request) async throws -> ExperienceDTO {
        guard let experienceId = req.parameters.get("experienceId", as: UUID.self),
              let experience = try await repository.findById(experienceId) else {
            throw Failed.idNotFound
        }
        return experience.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> ExperienceDTO {
        let experienceDTO = try req.content.decode(ExperienceDTO.self)
        let experience = experienceDTO.toModel()

        if let image = try? req.content.decode(File.self) {
            let imageURL = try await ImageUseCase().upload(image, on: req)
            experience.imageURL = imageURL
        }

        try await repository.create(
            experience,
            skills: experienceDTO.skills,
            projects: experienceDTO.projects
        )
        return experience.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let experienceId = req.parameters.get("experienceId", as: UUID.self),
                let experience = try await repository.findById(experienceId) else {
            throw Failed.idNotFound
        }

        try await repository.delete(experience)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> ExperienceDTO {
        guard let experienceId = req.parameters.get("experienceId", as: UUID.self),
              let experience = try await Experience.find(experienceId, on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedData = try req.content.decode(ExperienceDTO.self)
        // TODO: image handling
        experience.name = updatedData.name
        experience.type = updatedData.type
        experience.introduction = updatedData.introduction
        experience.period = updatedData.period
        experience.companyName = updatedData.companyName
        experience.missionDetails = updatedData.missionDetails

        try await repository.update(
            experience,
            skills: updatedData.skills,
            projects: updatedData.projects
        )
        return experience.toDTO()
    }

}
