import XCTest
@testable import LearningDashboard

@MainActor
final class CourseDetailsViewModelTests: XCTestCase {

    func testToggleLessonUpdatesProgress() {
        // Arrange
        let lesson1 = Lesson(id: 101, title: "Intro", isCompleted: false)
        let lesson2 = Lesson(id: 102, title: "Advanced", isCompleted: false)
        let course = Course(id: 1, title: "Test Course", instructor: "Tester", progress: 0, lessonsCount: 2, lessons: [lesson1, lesson2])
        
        let viewModel = CourseDetailsViewModel(course: course)
        
        // Act - Complete first lesson (1/2 = 50%)
        viewModel.toggleLesson(lessonId: 101)
        
        // Assert
        XCTAssertTrue(viewModel.course.lessons?[0].isCompleted ?? false)
        XCTAssertEqual(viewModel.course.progress, 50, "Progress should be 50% after completing 1 out of 2 lessons.")
        
        // Act - Complete second lesson (2/2 = 100%)
        viewModel.toggleLesson(lessonId: 102)
        
        // Assert
        XCTAssertTrue(viewModel.course.lessons?[1].isCompleted ?? false)
        XCTAssertEqual(viewModel.course.progress, 100, "Progress should be 100% after completing all lessons.")
        
        // Act - Unmark first lesson (1/2 = 50%)
        viewModel.toggleLesson(lessonId: 101)
        
        // Assert
        XCTAssertFalse(viewModel.course.lessons?[0].isCompleted ?? false)
        XCTAssertEqual(viewModel.course.progress, 50, "Progress should revert to 50%.")
    }
}
