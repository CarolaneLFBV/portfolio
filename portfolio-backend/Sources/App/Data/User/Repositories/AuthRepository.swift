import Fluent
import Vapor

extension User.Repositories {
    struct AuthRepository {
        let db: Database

        func findByEmail(_ email: String) async throws -> User.Entity? {
            guard let user = try await User.Entity.query(on: db)
                .filter(\.$email == email)
                .first() else {
                    return nil
            }
            return user
        }

        func verify(_ userCred: User.Entity.LoginCredentials) async throws -> User.Entity {
            guard let user = try await findByEmail(userCred.email) else {
                throw Failed.idNotFound
            }
            let isValidPassword = try Bcrypt.verify(userCred.password, created: user.password)
            guard isValidPassword else { throw Failed.invalidData }
            return user
        }

        func create(_ input: User.Dto.Input) async throws {
            let user = input.toModel()
            guard let password = input.password, !password.isEmpty else {
                throw Failed.invalidData
            }

            guard try await findByEmail(input.email) == nil else {
                throw Abort(.conflict, reason: "Email already exists")
            }

            let passwordHash = try Bcrypt.hash(password)
            user.password = passwordHash
            try await user.save(on: db)
        }
    }

}
