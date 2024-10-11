import Fluent
import Vapor

struct ExperienceController: RouteCollection {
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
        try await Experience.query(on: req.db)
            .with(\.$skills)
            .with(\.$projects)
            .all()
            .map {
            $0.toDTO()
        }
    }

    @Sendable
    func getExperience(req: Request) async throws -> ExperienceDTO {
        guard let experienceIDString = req.parameters.get("experienceId"),
              let experienceID = UUID(uuidString: experienceIDString) else {
            throw Abort(.badRequest)
        }

        guard let experience = try await Experience.query(on: req.db)
            .filter(\.$id == experienceID)
            .with(\.$skills)
            .with(\.$projects)
            .first() else {
            throw Failed.idNotFound
        }
        return experience.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> ExperienceDTO {
        let experienceDTO = try req.content.decode(ExperienceDTO.self)
        let experience = experienceDTO.toModel()

        try await experience.save(on: req.db)

        if !experienceDTO.skills.isEmpty {
            let skills = try await Skill.query(on: req.db)
                .filter(\.$id ~~ experienceDTO.skills)
                .all()
            try await experience.$skills.attach(skills, on: req.db)
        }

        if !experienceDTO.projects.isEmpty {
            let projects = try await Project.query(on: req.db)
                .filter(\.$id ~~ experienceDTO.projects)
                .all()
            try await experience.$projects.attach(projects, on: req.db)
        }

        try await experience.$skills.load(on: req.db)
        try await experience.$projects.load(on: req.db)
        return experience.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let experience = try await Experience.find(req.parameters.get("experienceId"), on: req.db) else {
            throw Failed.invalidData
        }

        try await experience.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> ExperienceDTO {
        guard let experienceId = req.parameters.get("experienceId", as: UUID.self),
              let experience = try await Experience.find(experienceId, on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedData = try req.content.decode(ExperienceDTO.self)

        experience.type = updatedData.type
        experience.startDate = updatedData.startDate
        experience.endDate = updatedData.endDate
        experience.position = updatedData.position ?? "N/A"
        experience.companyLogo = updatedData.companyLogo ?? "N/A"
        experience.companyName = updatedData.companyName ?? "N/A"
        experience.status = updatedData.status ?? "N/A"
        experience.missionDetails = updatedData.missionDetails ?? "N/A"
        experience.degree = updatedData.degree ?? "N/A"
        experience.misc = updatedData.misc ?? "N/A"

        try await Helpers.updateRelations(for: experience, skills: updatedData.skills, projects: updatedData.projects, db: req.db)
        try await experience.save(on: req.db)
        return experience.toDTO()
    }

}

extension ExperienceController {
    struct Helpers {
        static func updateRelations(for experience: Experience, skills: [UUID], projects: [UUID], db: Database) async throws {
            if skills.isEmpty {
                try await experience.$skills.detachAll(on: db)
            } else {
                let skills = try await Skill.query(on: db)
                    .filter(\.$id ~~ skills)
                    .all()
                try await experience.$skills.detachAll(on: db)
                try await experience.$skills.attach(skills, on: db)
            }

            if projects.isEmpty {
                try await experience.$projects.detachAll(on: db)
            } else {
                let projects = try await Project.query(on: db)
                    .filter(\.$id ~~ projects)
                    .all()
                try await experience.$projects.detachAll(on: db)
                try await experience.$projects.attach(projects, on: db)
            }
        }
    }
}
