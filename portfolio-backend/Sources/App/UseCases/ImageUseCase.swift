import Vapor
import Fluent
import Foundation

struct ImageUseCase {
    func upload(_ image: File, on req: Request) async throws -> String {
        let filename = "\(UUID()).\(image.extension ?? "jpg")"
        let path = req.application.directory.publicDirectory + "images/"
        try await req.fileio.writeFile(image.data, at: path + filename)
        return "images/\(filename)"
    }

    func delete(req: Request) async throws -> HTTPStatus {
        guard let imageURL = req.query[String.self, at: "url"] else {
            throw Abort(.badRequest, reason: "No image URL provided")
        }

        let path = req.application.directory.publicDirectory + imageURL
        try FileManager.default.removeItem(atPath: path)

        return .ok
    }
}
