import Foundation

protocol NetworkServiceProtocol {
    func fetchCourses() async throws -> [Course]
}

class NetworkService: NetworkServiceProtocol {
    
    func fetchCourses() async throws -> [Course] {
        let isConnected = await NetworkMonitor.isConnectedToNetwork()
        if !isConnected {
            throw NetworkError.offline
        }
        
        try await Task.sleep(nanoseconds: 1_500_000_000)
        
        let jsonString = """
        [
          {
            "id": 1,
            "title": "Python Programming",
            "instructor": "John Smith",
            "progress": 50,
            "lessonsCount": 4,
            "lessons": [
                {"id": 101, "title": "Introduction", "isCompleted": true},
                {"id": 102, "title": "Variables & Data Types", "isCompleted": true},
                {"id": 103, "title": "Functions", "isCompleted": false},
                {"id": 104, "title": "OOP", "isCompleted": false}
            ]
          },
          {
            "id": 2,
            "title": "Generative AI",
            "instructor": "Sarah Williams",
            "progress": 50,
            "lessonsCount": 2,
            "lessons": [
                {"id": 201, "title": "What is GenAI?", "isCompleted": true},
                {"id": 202, "title": "LLMs", "isCompleted": false}
            ]
          },
          {
            "id": 3,
            "title": "Full Stack Development",
            "instructor": "David Brown",
            "progress": 50,
            "lessonsCount": 2,
            "lessons": [
                {"id": 301, "title": "HTML/CSS Basics", "isCompleted": true},
                {"id": 302, "title": "JavaScript", "isCompleted": false}
            ]
          }
        ]
        """
        
        return try JSONParser.decode([Course].self, from: jsonString)
    }
}

struct JSONParser {
    static func decode<T: Decodable>(_ type: T.Type, from jsonString: String) throws -> T {
        guard let data = jsonString.data(using: .utf8) else {
            throw NetworkError.decodingError
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
