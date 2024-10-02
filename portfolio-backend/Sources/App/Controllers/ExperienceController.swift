import Fluent
import Vapor

struct ExperienceController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let experiences = routes.grouped("experiences")
        let experience = experiences.grouped(":expID")
        experiences.get(use: self.index)
        experience.get(use: self.getExperience)

        // JWT protection on experiences
        let protected = experiences.grouped([JWTAuthenticator()])
        protected.post(use: self.create)

        // JWT protection on one experience
        let protectedElement = protected.grouped(":expID")
        protectedElement.patch(use: self.update)
        protectedElement.delete(use: self.delete)
    }

    @Sendable
    func index(req: Request) async throws -> ExperiencesDTO {
        try await Experience.query(on: req.db).all().map {
            $0.toDTO()
        }
    }

    @Sendable
    func getExperience(req: Request) async throws -> ExperienceDTO {
        guard let experience = try await Experience.find(req.parameters.get("expID"), on: req.db) else {
            throw Abort(.notFound)
        }
        return experience.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> ExperienceDTO {
        let experience = try req.content.decode(ExperienceDTO.self).toModel()
        try await experience.save(on: req.db)
        return experience.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let experience = try await Experience.find(req.parameters.get("expID"), on: req.db) else {
            throw Abort(.badRequest)
        }

        try await experience.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> ExperienceDTO {
        guard let experience = try await Experience.find(req.parameters.get("expID"), on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedData = try req.content.decode(ExperienceDTO.self)

        experience.type = updatedData.type
        experience.startDate = updatedData.startDate
        experience.endDate = updatedData.endDate
        experience.position = updatedData.position ?? "Position held unavailable"
        experience.companyLogo = updatedData.companyLogo ?? "N/A"
        experience.companyName = updatedData.companyName ?? "Company's name unavailable"
        experience.status = updatedData.status ?? "Status unavailable"
        experience.missionDetails = updatedData.missionDetails ?? "Mission details unavailable"
        experience.$skill.id = updatedData.skillID
        experience.$project.id = updatedData.projectID
        experience.degree = updatedData.degree ?? "Degree unavailable"
        experience.misc = updatedData.misc ?? "Detail unavailable"

        try await experience.save(on: req.db)
        return experience.toDTO()
    }
}
