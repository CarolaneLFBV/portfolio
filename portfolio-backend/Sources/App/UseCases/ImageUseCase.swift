import Vapor
import Fluent
import Foundation

struct ImageUseCase {
    func upload(_ image: File, on req: Request) async throws -> String {
        let filename = "\(UUID()).\(image.extension ?? "jpg")"
        let path = getImagePath(req: req) + filename
        try await req.fileio.writeFile(image.data, at: path)
        return "\(filename)"
    }

    func delete(at imagePath: String, on req: Request) async throws {
        let path = getImagePath(req: req) + imagePath
        try FileManager.default.removeItem(atPath: path)
    }

    private func getImagePath(subDirectory: String = "images", req: Request) -> String {
        req.application.directory.publicDirectory + subDirectory + "/"
    }
}
