import Fluent
import Vapor

struct SkillController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let skills = routes.grouped("skills")
        let skill = skills.grouped(":skillId")
        skills.get(use: self.index)
        skill.get(use: self.getSkill)

        let protected = skills.grouped([
            JWTAuthAuthenticator(),
            RoleMiddleware(requiredRole: .admin),
            User.guardMiddleware()
        ])
        protected.post("create", use: self.create)

        let protectedElement = protected.grouped(":skillId")
        protectedElement.patch(use: self.update)
        protectedElement.delete(use: self.delete)

    }
}

extension SkillController {
    @Sendable
    func index(req: Request) async throws -> SkillsDTO {
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
        guard let skillId = req.parameters.get("skillId", as: UUID.self) else {
            throw Failed.invalidData
        }

        guard let skill = try await Skill.query(on: req.db)
            .filter(\.$id == skillId)
            .with(\.$projects)
            .with(\.$experiences)
            .first() else {
            throw Failed.idNotFound
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
        guard let skill = try await Skill.find(req.parameters.get("skillId"), on: req.db) else {
            throw Failed.idNotFound
        }

        try await skill.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> SkillDTO {
        guard let skillId = req.parameters.get("skillId", as: UUID.self),
              let skill = try await Skill.find(skillId, on: req.db) else {
            throw Failed.idNotFound
        }

        let updatedData = try req.content.decode(SkillDTO.self)

        skill.name = updatedData.name
        skill.tags = updatedData.tags
        skill.context = updatedData.context
        skill.proofs = updatedData.proofs
        skill.retrospective = updatedData.retrospective
        skill.progress = updatedData.progress

        try await Helpers.updateRelations(for: skill, projects: updatedData.projects, experiences: updatedData.experiences, db: req.db)
        try await skill.save(on: req.db)
        return skill.toDTO()
    }
}

extension SkillController {
    struct Helpers {
        static func updateRelations(for skill: Skill, projects: [UUID], experiences: [UUID], db: Database) async throws {

            if projects.isEmpty {
                try await skill.$projects.detachAll(on: db)
            } else {
                let projects = try await Project.query(on: db)
                    .filter(\.$id ~~ projects)
                    .all()
                try await skill.$projects.detachAll(on: db)
                try await skill.$projects.attach(projects, on: db)
            }

            if experiences.isEmpty {
                try await skill.$experiences.detachAll(on: db)
            } else {
                let experiences = try await Experience.query(on: db)
                    .filter(\.$id ~~ experiences)
                    .all()
                try await skill.$experiences.detachAll(on: db)
                try await skill.$experiences.attach(experiences, on: db)
            }
        }
    }
}
