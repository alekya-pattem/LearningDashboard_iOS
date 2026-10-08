import Foundation
import Combine

@MainActor
class CourseDetailsViewModel: ObservableObject {
    @Published var course   : Course
    let repository          : CourseRepository
    
    init(course: Course, repository: CourseRepository? = nil) {
        self.course = course
        self.repository = repository ?? CourseRepository()
    }
    
    func toggleLesson(lessonId: Int) {
        guard let index = course.lessons?.firstIndex(where: { $0.id == lessonId }) else { return }
        
        course.lessons?[index].isCompleted?.toggle()
        
        let completedCount = course.lessons?.filter { $0.isCompleted ?? false }.count
        
        if let lessons = course.lessons {
            course.progress = Int((Double(completedCount ?? 0) / Double(lessons.count)) * 100)
        }
        
        // Save to repository
        repository.updateLesson(courseId: course.id ?? 0, lessonId: lessonId, isCompleted: course.lessons?[index].isCompleted ?? false)
    }
}
