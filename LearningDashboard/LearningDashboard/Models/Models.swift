import Foundation

struct Course: Identifiable, Codable {
    let id          : Int?
    let title       : String?
    let instructor  : String?
    var progress    : Int?
    let lessonsCount: Int?
    var lessons     : [Lesson]?
}

struct Lesson: Identifiable, Codable {
    let id          : Int?
    let title       : String?
    var isCompleted : Bool?
}
