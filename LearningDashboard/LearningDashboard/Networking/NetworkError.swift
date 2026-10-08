import Foundation

enum NetworkError: Error {
    case invalidURL
    case decodingError
    case serverError
    case offline
}
