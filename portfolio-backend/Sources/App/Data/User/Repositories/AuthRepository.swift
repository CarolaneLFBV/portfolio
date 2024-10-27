import Fluent
import Vapor

struct AuthRepository {
    let db: Database

    func findUserByEmail(_ email: String) async throws -> User? {
        return try await User.query(on: db)
            .filter(\.$email == email)
            .first()
    }

    func saveUser(_ user: User) async throws {
        try await user.save(on: db)
    }
}
