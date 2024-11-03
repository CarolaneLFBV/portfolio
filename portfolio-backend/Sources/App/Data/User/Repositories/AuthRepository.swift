import Fluent
import Vapor

extension User.Repositories {
    struct AuthRepository {
        typealias UserOutput = User.Dto.Output
        let db: Database

        func findUserByEmail(_ email: String) async throws -> User.Entity? {
            guard let user = try await User.Entity.query(on: db)
                .filter(\.$email == email)
                .first() else {
                    return nil
            }
            return user
        }

        func saveUser(_ user: User.Entity) async throws {
            try await user.save(on: db)
        }
    }

}
