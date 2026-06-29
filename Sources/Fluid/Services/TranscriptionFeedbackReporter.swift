import Foundation

enum TranscriptionFeedbackReporter {
    struct Payload: Encodable {
        let rawText: String
        let processedText: String
        let processingModel: String
        let comments: String
    }

    enum ReporterError: LocalizedError {
        case notConfigured

        var errorDescription: String? {
            switch self {
            case .notConfigured:
                return "Example sharing is not configured in the AI Answer fork yet. Please copy the example into a GitHub issue only if it is safe to share."
            }
        }
    }

    static func submit(_ payload: Payload) async throws {
        _ = payload
        throw ReporterError.notConfigured
    }
}
