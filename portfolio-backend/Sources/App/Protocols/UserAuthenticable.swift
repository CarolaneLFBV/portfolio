import Foundation
import Fluent
import Vapor

protocol UserAuthenticable {
    associatedtype Entity
    associatedtype Input
    associatedtype Output

    func findAll() async throws -> [Output]
    func find(_ id: UUID) async throws -> Output?
    func saveUser(_ input: Input, on req: Request) async throws
    func deleteUser(_ entity: Entity) async throws
}
