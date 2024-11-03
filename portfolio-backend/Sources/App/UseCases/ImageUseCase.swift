import Vapor
import Fluent
import Foundation

struct ImageUseCase {
    func upload(_ image: File, on req: Request, subDirectory: String = "images") async throws -> String {
        let filename = "\(UUID()).\(image.extension ?? "jpg")"
        let path = req.application.directory.publicDirectory + subDirectory + "/" + filename
        try await req.fileio.writeFile(image.data, at: path)
        return "/\(subDirectory)/\(filename)"
    }

    func delete(at imagePath: String, on req: Request) async throws -> HTTPStatus {
        let path = req.application.directory.publicDirectory + imagePath
        try FileManager.default.removeItem(atPath: path)
        return .noContent
    }
}
