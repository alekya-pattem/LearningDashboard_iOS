import Foundation

class CourseRepository {
    let networkService: NetworkServiceProtocol
    let storageService: StorageServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         storageService: StorageServiceProtocol = StorageService()) {
        self.networkService = networkService
        self.storageService = storageService
    }
    
    func fetchCourses() async throws -> [Course] {
        do {
            let courses = try await networkService.fetchCourses()
            storageService.saveCourses(courses)
            return storageService.getCourses()
        } catch {
            let cachedCourses = storageService.getCourses()
            if !cachedCourses.isEmpty {
                return cachedCourses
            }
            throw error
        }
    }
    
    func updateLesson(courseId: Int, lessonId: Int, isCompleted: Bool) {
        storageService.updateLessonCompletion(courseId: courseId, lessonId: lessonId, isCompleted: isCompleted)
    }
}
