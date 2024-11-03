import Foundation
import Fluent
import Vapor

protocol Crudable {
    associatedtype Entity
    associatedtype Input

    func findAll() async throws -> [Entity]
    func find(_ id: UUID) async throws -> Entity?

    func create(_ input: Input) async throws
    func update(_ input: Input) async throws

    func delete(_ entity: Entity) async throws
}
