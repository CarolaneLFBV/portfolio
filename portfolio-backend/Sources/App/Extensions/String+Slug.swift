import Foundation

extension String {
    func slug() -> String {
        self.lowercased().replacingOccurrences(of: " ", with: "-")
    }
}
