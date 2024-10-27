import Fluent
import Vapor

protocol UserProtocol {
    func getAllUsers() async throws -> [User]
    func findById(_ id: UUID) async throws -> User?
    func saveUser(_ user: User) async throws
    func deleteUser(_ user: User) async throws
}

struct UserRepository: UserProtocol {
    let db: Database

    func getAllUsers() async throws -> [User] {
        try await User.query(on: db).all()
    }

    func findById(_ id: UUID) async throws -> User? {
        try await User.find(id, on: db)
    }

    func saveUser(_ user: User) async throws {
        try await user.save(on: db)
    }

    func deleteUser(_ user: User) async throws {
        try await user.delete(on: db)
    }
}
