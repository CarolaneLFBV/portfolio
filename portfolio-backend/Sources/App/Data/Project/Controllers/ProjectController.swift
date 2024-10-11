import Fluent
import Vapor

struct ProjectController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let projects = routes.grouped("projects")
        let project = projects.grouped(":projectID")
        projects.get(use: self.index)
        project.get(use: self.getProject)

        let protected = projects.grouped([JWTAuthAuthenticator(), RoleMiddleware(requiredRole: .admin), User.guardMiddleware()])
        protected.post("create", use: self.create)

        let protectedElement = protected.grouped(":projectID")
        protectedElement.patch(use: self.update)
        protectedElement.delete(use: self.delete)
    }
}

extension ProjectController {
    @Sendable
    func index(req: Request) async throws -> ProjectsDTO {
        try await Project.query(on: req.db)
            .with(\.$skills)
            .with(\.$experiences)
            .all()
            .map {
            $0.toDTO()
        }
    }

    @Sendable
    func getProject(req: Request) async throws -> ProjectDTO {
        guard let projectID = req.parameters.get("projectID", as: UUID.self) else {
            throw Failed.idNotFound
        }

        guard let project = try await Project.query(on: req.db)
            .filter(\.$id == projectID)
            .with(\.$skills)
            .with(\.$experiences)
            .first() else {
            throw Failed.idNotFound
        }
        return project.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> ProjectDTO {
        let projectDTO = try req.content.decode(ProjectDTO.self)
        let project = projectDTO.toModel()

        try await project.save(on: req.db)

        if !projectDTO.skills.isEmpty {
            let skills = try await Skill.query(on: req.db)
                .filter(\.$id ~~ projectDTO.skills)
                .all()
            try await project.$skills.attach(skills, on: req.db)
        }

        if !projectDTO.experiences.isEmpty {
            let experiences = try await Experience.query(on: req.db)
                .filter(\.$id ~~ projectDTO.experiences)
                .all()
            try await project.$experiences.attach(experiences, on: req.db)
        }

        try await project.$skills.load(on: req.db)
        try await project.$experiences.load(on: req.db)
        return project.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let project = try await Project.find(req.parameters.get("projectID"), on: req.db) else {
            throw Failed.idNotFound
        }

        try await project.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> ProjectDTO {
        guard let projectID = req.parameters.get("projectID", as: UUID.self),
              let project = try await Project.find(projectID, on: req.db) else {
            throw Failed.idNotFound
        }

        let updatedData = try req.content.decode(ProjectDTO.self)

        project.title = updatedData.title
        project.presentation = updatedData.presentation
        project.purpose = updatedData.purpose
        project.milestone = updatedData.milestone
        project.actor = updatedData.actor
        project.progress = updatedData.progress

        try await Helpers.updateRelation(for: project, skills: updatedData.skills, experiences: updatedData.experiences, db: req.db)
        try await project.save(on: req.db)
        return project.toDTO()
    }
}

extension ProjectController {
    struct Helpers {
        static func updateRelation(for project: Project, skills: [UUID], experiences: [UUID], db: Database) async throws {
            if skills.isEmpty {
                try await project.$skills.detachAll(on: db)
            } else {
                let skills = try await Skill.query(on: db)
                    .filter(\.$id ~~ skills)
                    .all()
                try await project.$skills.detachAll(on: db)
                try await project.$skills.attach(skills, on: db)
            }

            if experiences.isEmpty {
                try await project.$experiences.detachAll(on: db)
            } else {
                let experiences = try await Experience.query(on: db)
                    .filter(\.$id ~~ experiences)
                    .all()
                try await project.$experiences.detachAll(on: db)
                try await project.$experiences.attach(experiences, on: db)
            }
        }
    }
}
