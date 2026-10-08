import Foundation
import Combine

enum ViewState {
    case loading
    case loaded
    case empty
    case error(String)
}

@MainActor
class CourseDashboardViewModel: ObservableObject {
    @Published var courses  : [Course] = []
    @Published var state    : ViewState = .loading
    let repository          : CourseRepository
    
    init(repository: CourseRepository? = nil) {
        self.repository = repository ?? CourseRepository()
    }
    
    func loadCourses() async {
        state = .loading
        do {
            let fetchedCourses = try await repository.fetchCourses()
            self.courses = fetchedCourses
            if fetchedCourses.isEmpty {
                state = .empty
            } else {
                state = .loaded
            }
        } catch {
            state = .error("Failed to load courses. Please try again.")
        }
    }
    
    func refresh() async {
        do {
            let fetchedCourses = try await repository.fetchCourses()
            self.courses = fetchedCourses
            if fetchedCourses.isEmpty {
                state = .empty
            } else {
                state = .loaded
            }
        } catch {
            if self.courses.isEmpty {
                state = .error("Failed to refresh.")
            }
        }
    }
    
    func reloadFromCache() {
        let cached = repository.storageService.getCourses()
        if !cached.isEmpty {
            self.courses = cached
            state = .loaded
        }
    }
}
