import CoreData

class StorageService {
    let context = CoreDataStack.shared.context
    
    func saveCourses(_ courses: [Course]) {
        // Fetch existing courses to retain local progress
        let existingCourses = getCourses()
        var completedLessonIds = Set<Int>()
        for course in existingCourses {
            for lesson in course.lessons ?? [] {
                if lesson.isCompleted == true, let id = lesson.id {
                    completedLessonIds.insert(id)
                }
            }
        }
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "CourseEntity")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        _ = try? context.execute(deleteRequest)
        context.reset()
        
        for course in courses {
            let entity = CourseEntity(context: context)
            entity.id = Int64(course.id ?? 0)
            entity.title = course.title ?? ""
            entity.instructor = course.instructor ?? ""
            entity.lessonsCount = Int64(course.lessonsCount ?? 0)
            
            var completedCount = 0
            
            for lesson in course.lessons ?? [] {
                let lessonEntity = LessonEntity(context: context)
                lessonEntity.id = Int64(lesson.id ?? 0)
                lessonEntity.title = lesson.title ?? ""
                
                // Retain local completion status if it exists
                if let id = lesson.id, completedLessonIds.contains(id) {
                    lessonEntity.isCompleted = true
                    completedCount += 1
                } else {
                    lessonEntity.isCompleted = lesson.isCompleted ?? false
                    if lessonEntity.isCompleted {
                        completedCount += 1
                    }
                }
                
                lessonEntity.course = entity
            }
            
            // Recalculate course progress
            let totalLessons = course.lessons?.count ?? 0
            if totalLessons > 0 {
                entity.progress = Int64((Double(completedCount) / Double(totalLessons)) * 100)
            } else {
                entity.progress = Int64(course.progress ?? 0)
            }
        }
        
        CoreDataStack.shared.saveContext()
    }
    
    func getCourses() -> [Course] {
        let request = NSFetchRequest<CourseEntity>(entityName: "CourseEntity")
        let sort = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [sort]
        
        do {
            let entities = try context.fetch(request)
            return entities.map { entity in
                let lessonEntities = (entity.lessons?.allObjects as? [LessonEntity])?.sorted(by: { $0.id < $1.id }) ?? []
                let lessons = lessonEntities.map { Lesson(id: Int($0.id), title: $0.title, isCompleted: $0.isCompleted) }
                return Course(id: Int(entity.id), title: entity.title, instructor: entity.instructor, progress: Int(entity.progress), lessonsCount: Int(entity.lessonsCount), lessons: lessons)
            }
        } catch {
            print("Failed to fetch courses: \(error)")
            return []
        }
    }
    
    func updateLessonCompletion(courseId: Int, lessonId: Int, isCompleted: Bool) {
        let request = NSFetchRequest<CourseEntity>(entityName: "CourseEntity")
        request.predicate = NSPredicate(format: "id == %d", courseId)
        
        if let course = try? context.fetch(request).first {
            if let lessons = course.lessons?.allObjects as? [LessonEntity], let lesson = lessons.first(where: { $0.id == Int64(lessonId) }) {
                lesson.isCompleted = isCompleted
                
                let completedCount = lessons.filter { $0.isCompleted }.count
                if !lessons.isEmpty {
                    course.progress = Int64((Double(completedCount) / Double(lessons.count)) * 100)
                }
                CoreDataStack.shared.saveContext()
            }
        }
    }
}
