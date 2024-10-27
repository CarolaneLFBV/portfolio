import Fluent
import Vapor

struct ProjectController: RouteCollection {
    private let repository: ProjectRepository

    init(repository: ProjectRepository) {
        self.repository = repository
    }

    func boot(routes: any RoutesBuilder) throws {
        let projects = routes.grouped("projects")
        let project = projects.grouped(":projectId")
        projects.get(use: self.index)
        project.get(use: self.getProject)

        let protected = projects.grouped([
            JWTAuthAuthenticator(),
            RoleMiddleware(requiredRole: .admin),
            User.guardMiddleware()
        ])
        protected.post("create", use: self.create)
        let protectedElement = protected.grouped(":projectId")
        protectedElement.patch(use: self.update)
        protectedElement.delete(use: self.delete)
    }
}

extension ProjectController {
    @Sendable
    func index(req: Request) async throws -> ProjectsDTO {
        let projects = try await repository.findAll()
        return projects.map { $0.toDTO() }
    }

    @Sendable
    func getProject(req: Request) async throws -> ProjectDTO {
        guard let projectId = req.parameters.get("projectId", as: UUID.self),
              let project = try await repository.findById(projectId) else {
            throw Failed.idNotFound
        }
        return project.toDTO()
    }

    @Sendable
    func create(req: Request) async throws -> ProjectDTO {
        let projectDTO = try req.content.decode(ProjectDTO.self)
        let project = projectDTO.toModel()

        if let image = try? req.content.decode(File.self) {
            let imageURL = try await ImageUseCase().upload(image, on: req)
            project.imageURL = imageURL
        }

        try await repository.create(
            project,
            skills: projectDTO.skills,
            experiences: projectDTO.experiences
        )
        return project.toDTO()
    }

    @Sendable
    func delete(req: Request) async throws -> HTTPStatus {
        guard let projectId = req.parameters.get("projectId", as: UUID.self),
                let project = try await repository.findById(projectId) else {
            throw Failed.idNotFound
        }

        try await repository.delete(project)
        return .noContent
    }

    @Sendable
    func update(req: Request) async throws -> ProjectDTO {
        guard let projectId = req.parameters.get("projectId", as: UUID.self),
              let project = try await Project.find(projectId, on: req.db) else {
            throw Failed.idNotFound
        }

        let updatedData = try req.content.decode(ProjectDTO.self)
        // TODO: image handling
        project.name = updatedData.name
        project.introduction = updatedData.introduction
        project.presentation = updatedData.presentation
        project.context = updatedData.context
        project.technicalDetails = updatedData.technicalDetails

        try await repository.update(
            project,
            skills: updatedData.skills,
            experiences: updatedData.experiences
        )
        return project.toDTO()
    }
}
