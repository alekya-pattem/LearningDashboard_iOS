import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let model = NSManagedObjectModel()
        
        let courseEntity = NSEntityDescription()
        courseEntity.name = "CourseEntity"
        courseEntity.managedObjectClassName = NSStringFromClass(CourseEntity.self)
        
        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .integer64AttributeType
        
        let titleAttr = NSAttributeDescription()
        titleAttr.name = "title"
        titleAttr.attributeType = .stringAttributeType
        
        let instructorAttr = NSAttributeDescription()
        instructorAttr.name = "instructor"
        instructorAttr.attributeType = .stringAttributeType
        
        let progressAttr = NSAttributeDescription()
        progressAttr.name = "progress"
        progressAttr.attributeType = .integer64AttributeType
        
        let lessonsCountAttr = NSAttributeDescription()
        lessonsCountAttr.name = "lessonsCount"
        lessonsCountAttr.attributeType = .integer64AttributeType
        
        courseEntity.properties = [idAttr, titleAttr, instructorAttr, progressAttr, lessonsCountAttr]
        
        let lessonEntity = NSEntityDescription()
        lessonEntity.name = "LessonEntity"
        lessonEntity.managedObjectClassName = NSStringFromClass(LessonEntity.self)
        
        let lessonIdAttr = NSAttributeDescription()
        lessonIdAttr.name = "id"
        lessonIdAttr.attributeType = .integer64AttributeType
        
        let lessonTitleAttr = NSAttributeDescription()
        lessonTitleAttr.name = "title"
        lessonTitleAttr.attributeType = .stringAttributeType
        
        let isCompletedAttr = NSAttributeDescription()
        isCompletedAttr.name = "isCompleted"
        isCompletedAttr.attributeType = .booleanAttributeType
        
        lessonEntity.properties = [lessonIdAttr, lessonTitleAttr, isCompletedAttr]
        
        let courseToLessons = NSRelationshipDescription()
        courseToLessons.name = "lessons"
        courseToLessons.destinationEntity = lessonEntity
        courseToLessons.maxCount = 0
        courseToLessons.minCount = 0
        courseToLessons.deleteRule = .cascadeDeleteRule
        
        let lessonToCourse = NSRelationshipDescription()
        lessonToCourse.name = "course"
        lessonToCourse.destinationEntity = courseEntity
        lessonToCourse.maxCount = 1
        lessonToCourse.minCount = 1
        lessonToCourse.deleteRule = .nullifyDeleteRule
        
        courseToLessons.inverseRelationship = lessonToCourse
        lessonToCourse.inverseRelationship = courseToLessons
        
        courseEntity.properties.append(courseToLessons)
        lessonEntity.properties.append(lessonToCourse)
        
        model.entities = [courseEntity, lessonEntity]
        
        let container = NSPersistentContainer(name: "LearningDashboard", managedObjectModel: model)
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading CoreData: \(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
}

@objc(CourseEntity)
public class CourseEntity: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var instructor: String
    @NSManaged public var progress: Int64
    @NSManaged public var lessonsCount: Int64
    @NSManaged public var lessons: NSSet?
}

@objc(LessonEntity)
public class LessonEntity: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var title: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var course: CourseEntity?
}
