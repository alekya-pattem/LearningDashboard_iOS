import Foundation

class CourseRepository {
    let networkService = NetworkService()
    let storageService = StorageService()
    
    func fetchCourses() async throws -> [Course] {
        do {
            let courses = try await networkService.fetchCourses()
            storageService.saveCourses(courses)
            // Return the merged data from CoreData
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
