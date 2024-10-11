import Fluent
import Vapor

struct SkillController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let skills = routes.grouped("skills")
        let skill = skills.grouped(":skillID")
        skills.get(use: self.index)
        skill.get(use: self.getSkill)

        let protected = skills.grouped([JWTAuthAuthenticator(), RoleMiddleware(requiredRole: .admin), User.guardMiddleware()])
        protected.post("create", use: self.create)

        let protectedElement = protected.grouped(":skillID")
        protectedElement.patch(use: self.update)
        protectedElement.delete(use: self.delete)

    }
}

extension SkillController {
    @Sendable
    func index(req: Request) async throws -> [SkillDTO] {
        try await Skill.query(on: req.db)
            .with(\.$projects)
            .with(\.$experiences)
            .all()
            .map {
            $0.toDTO()
        }
    }

    @Sendable
    func getSkill(req: Request) async throws -> SkillDTO {
        guard let skillIDString = req.parameters.get("skillID"),
              let skillID = UUID(uuidString: skillIDString) else {
            throw Abort(.badRequest)
        }

        guard let skill = try await Skill.query(on: req.db)
            .filter(\.$id == skillID)
            .with(\.$projects)
            .with(\.$experiences)
            .first() else {
            throw Abort(.notFound)
        }
        return skill.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> SkillDTO {
        let skillDTO = try req.content.decode(SkillDTO.self)
        let skill = skillDTO.toModel()

        try await skill.save(on: req.db)

        if !skillDTO.projects.isEmpty {
            let projects = try await Project.query(on: req.db)
                .filter(\.$id ~~ skillDTO.projects)
                .all()
            try await skill.$projects.attach(projects, on: req.db)
        }

        if !skillDTO.experiences.isEmpty {
            let experiences = try await Experience.query(on: req.db)
                .filter(\.$id ~~ skillDTO.experiences)
                .all()
            try await skill.$experiences.attach(experiences, on: req.db)
        }

        try await skill.$projects.load(on: req.db)
        try await skill.$experiences.load(on: req.db)
        return skill.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let skill = try await Skill.find(req.parameters.get("skillID"), on: req.db) else {
            throw Abort(.notFound)
        }

        try await skill.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> SkillDTO {
        guard let skillIDString = req.parameters.get("skillID"),
              let skillID = UUID(uuidString: skillIDString),
              let skill = try await Skill.find(skillID, on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedData = try req.content.decode(SkillDTO.self)

        skill.name = updatedData.name
        skill.tags = updatedData.tags
        skill.context = updatedData.context
        skill.proofs = updatedData.proofs
        skill.retrospective = updatedData.retrospective
        skill.progress = updatedData.progress

        try await skill.$projects.load(on: req.db)
        try await skill.$experiences.load(on: req.db)

        if !updatedData.projects.isEmpty {
            let projects = try await Project.query(on: req.db)
                .filter(\.$id ~~ updatedData.projects)
                .all()
            try await skill.$projects.detachAll(on: req.db)
            try await skill.$projects.attach(projects, on: req.db)
        } else {
            try await skill.$projects.detachAll(on: req.db)
        }

        if !updatedData.experiences.isEmpty {
            let experiences = try await Experience.query(on: req.db)
                .filter(\.$id ~~ updatedData.experiences)
                .all()
            try await skill.$experiences.detachAll(on: req.db)
            try await skill.$experiences.attach(experiences, on: req.db)
        } else {
            try await skill.$experiences.detachAll(on: req.db)
        }

        try await skill.save(on: req.db)
        return skill.toDTO()
    }
}
