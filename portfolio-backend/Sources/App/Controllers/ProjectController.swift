import Fluent
import Vapor

struct ProjectController: RouteCollection {
    func boot(routes: any RoutesBuilder) throws {
        let projects = routes.grouped("projects")
        let project = projects.grouped(":projectID")
        projects.get(use: self.index)
        project.get(use: self.getProject)

        let protected = projects.grouped([JWTAuthenticator()])
        protected.post("create", use: self.create)

        let protectedElement = protected.grouped(":projectID")
        protectedElement.patch(use: self.update)
        protectedElement.delete(use: self.delete)
    }

    @Sendable
    func index(req: Request) async throws -> [ProjectDTO] {
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
        guard let projectIDString = req.parameters.get("projectID"),
              let projectID = UUID(uuidString: projectIDString) else {
            throw Abort(.badRequest)
        }

        guard let project = try await Project.query(on: req.db)
            .filter(\.$id == projectID)
            .with(\.$skills)
            .with(\.$experiences)
            .first() else {
            throw Abort(.notFound)
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
            throw Abort(.notFound)
        }

        try await project.delete(on: req.db)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> ProjectDTO {
        guard let projectIDString = req.parameters.get("projectID"),
              let projectID = UUID(uuidString: projectIDString),
              let project = try await Project.find(projectID, on: req.db) else {
            throw Abort(.notFound)
        }

        let updatedData = try req.content.decode(ProjectDTO.self)

        project.title = updatedData.title
        project.presentation = updatedData.presentation
        project.purpose = updatedData.purpose
        project.milestone = updatedData.milestone
        project.actor = updatedData.actor
        project.progress = updatedData.progress

        try await project.$skills.load(on: req.db)
        try await project.$experiences.load(on: req.db)

        if !updatedData.skills.isEmpty {
            let skills = try await Skill.query(on: req.db)
                .filter(\.$id ~~ updatedData.skills)
                .all()

            try await project.$skills.detachAll(on: req.db)
            try await project.$skills.attach(skills, on: req.db)
        } else {
            try await project.$skills.detachAll(on: req.db)
        }

        if !updatedData.experiences.isEmpty {
            let experiences = try await Experience.query(on: req.db)
                .filter(\.$id ~~ updatedData.experiences)
                .all()
            try await project.$experiences.detachAll(on: req.db)
            try await project.$experiences.attach(experiences, on: req.db)
        } else {
            try await project.$experiences.detachAll(on: req.db)
        }

        try await project.save(on: req.db)
        return project.toDTO()
    }
}
