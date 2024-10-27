import Fluent
import Vapor

protocol ExperienceProtocol {
    func findAll() async throws -> [Experience]
    func findById(_ id: UUID) async throws -> Experience?
    func create(_ experience: Experience, skills: [UUID], projects: [UUID]) async throws
    func update(_ experience: Experience, skills: [UUID], projects: [UUID]) async throws
    func delete(_ experience: Experience) async throws
}

struct ExperienceRepository: ExperienceProtocol {
    let db: Database

    func findAll() async throws -> [Experience] {
        try await Experience.query(on: db)
            .with(\.$skills)
            .with(\.$projects)
            .all()
    }

    func findById(_ id: UUID) async throws -> Experience? {
        try await Experience.query(on: db)
            .filter(\.$id == id)
            .with(\.$skills)
            .with(\.$projects)
            .first()
    }

    func create(_ experience: Experience, skills: [UUID], projects: [UUID]) async throws {
        try await experience.save(on: db)

        if !skills.isEmpty {
            let skillModels = try await Skill.query(on: db).filter(\.$id ~~ skills).all()
            try await experience.$skills.attach(skillModels, on: db)
        }

        if !projects.isEmpty {
            let projectModels = try await Project.query(on: db).filter(\.$id ~~ projects).all()
            try await experience.$projects.attach(projectModels, on: db)
        }

        try await experience.$skills.load(on: db)
        try await experience.$projects.load(on: db)
    }

    func update(_ experience: Experience, skills: [UUID], projects: [UUID]) async throws {
        try await experience.$skills.load(on: db)
        try await experience.$projects.load(on: db)

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
        try await experience.update(on: db)
    }

    func delete(_ experience: Experience) async throws {
        try await experience.delete(on: db)
    }
}
